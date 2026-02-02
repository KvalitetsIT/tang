# Alpine with Tang

This Docker image provides a Tang server running on Alpine Linux. Tang is a service for binding data to network presence, commonly used for network-bound disk encryption (NBDE) with Clevis.

## Features

- Lightweight Alpine Linux base
- Automatic key generation on first run
- Persistent key storage via Docker volume
- Listens on port 8080
- Includes Software Bill of Materials (SBOM) and build provenance

## Prerequisites

- Docker

## Building the Image

```bash
docker build -t tang .
```

## Running the Container

Run the Tang server with persistent key storage:

```bash
docker run -d -p 8080:8080 -v tang-keys:/var/db/tang --name tang tang
```

- `-d`: Run in detached mode
- `-p 8080:8080`: Map container port 8080 to host port 8080
- `-v tang-keys:/var/db/tang`: Use named volume for persistent key storage
- `--name tang`: Name the container for easy management

## Testing the Server

Check that the server is running and accessible:

```bash
curl http://localhost:8080/adv
```

This should return a JSON response with the server's advertisement, including public keys.

## Key Management

Keys are automatically generated on first run and stored in the `/var/db/tang` directory within the container. The volume `tang-keys` ensures keys persist across container restarts.

## Stopping and Cleaning Up

```bash
docker stop tang
docker rm tang
```

To remove the volume and keys:

```bash
docker volume rm tang-keys
```

## Kubernetes Deployment with Helm

This project includes a Helm chart for deploying the Tang server on Kubernetes.

### Prerequisites

- Kubernetes cluster
- Helm 3.x
- The Tang Docker image built and available in your registry

### Installing the Chart

First, ensure the Tang image is available in your cluster (e.g., push to a registry or use a local registry).

Install the chart with default values:

```bash
helm install tang ./chart
```

Or with custom values:

```bash
helm install tang ./chart --set image.repository=myregistry/tang --set image.tag=v1.0
```

To enable ingress:

```bash
helm install tang ./chart --set ingress.enabled=true --set ingress.hosts[0].host=tang.example.com
```

### Configuration

The following table lists the configurable parameters of the Tang chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of Tang replicas | `1` |
| `image.repository` | Tang image repository | `tang` |
| `image.tag` | Tang image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `8080` |
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress hosts configuration | `[{"host": "tang.local", "paths": [{"path": "/", "pathType": "Prefix"}]}]` |
| `ingress.tls` | Ingress TLS configuration | `[]` |
| `persistence.accessMode` | PVC access mode | `ReadWriteOnce` |
| `persistence.size` | PVC size | `1Gi` |
| `persistence.storageClass` | Storage class for PVC | `""` |
| `securityContext` | Pod security context | See values.yaml |
| `readinessProbe` | Container readiness probe configuration | See values.yaml |
| `resources` | CPU/Memory resource requests/limits | `{"limits": {"cpu": "100m", "memory": "128Mi"}, "requests": {"cpu": "50m", "memory": "64Mi"}}` |

**Note**: When `replicaCount > 1`, pods will automatically use `podAntiAffinity` to run on different nodes for high availability.

### Testing the Deployment

Get the service details:

```bash
kubectl get svc tang
```

Port forward to test locally:

```bash
kubectl port-forward svc/tang 8080:8080
curl http://localhost:8080/adv
```

### Uninstalling the Chart

```bash
helm uninstall tang
```

To remove the PVC:

```bash
kubectl delete pvc tang
``` 

