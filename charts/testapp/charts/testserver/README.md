# testserver

![Version: 0.9.51](https://img.shields.io/badge/Version-0.9.51-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.9.13](https://img.shields.io/badge/AppVersion-0.9.13-informational?style=flat-square)

A Flask test application for various
connections and configuration variations.
Helm charts to test various CI/CD, orchestration and deployment methods.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling | object | `{"enabled":false,"maxReplicas":3,"minReplicas":1,"targetCPUUtilizationPercentage":70}` | Horizontal scaling settings. |
| database.enabled | bool | `false` |  |
| env | list | `[{"name":"SECRET_KEY","value":"HelmChartSecret"},{"name":"REDIS_HOST","value":"None"},{"name":"REDIS_PASSWORD","value":"None"}]` | Basic application settings, see test-server README for full details. |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"cgerull/testserver"` |  |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` |  |
| ingress | object | `{"enabled":false,"tls":[],"traefikStripPrefix":""}` | Set to fit target environment |
| labels | object | `{"app.kubernetes.io/app":"testsuite"}` | Extra labels |
| livenessProbe.httpGet.path | string | `"/health"` |  |
| livenessProbe.httpGet.port | string | `"http"` |  |
| localSecrets.enabled | bool | `false` |  |
| localSecrets.secrets[0].mountPath | string | `"/run/secret/my-secret"` |  |
| localSecrets.secrets[0].name | string | `"testsecret"` |  |
| localSecrets.secrets[0].secretName | string | `"my_secret"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.enabled | bool | `false` |  |
| persistence.snapshots | bool | `false` |  |
| persistence.volumes[0].accessMode | string | `"ReadWriteMany"` |  |
| persistence.volumes[0].claimName | string | `"testserver-data"` |  |
| persistence.volumes[0].mountPath | string | `"/data"` |  |
| persistence.volumes[0].name | string | `"testserver-data"` |  |
| persistence.volumes[0].size | string | `"1Gi"` |  |
| persistence.volumes[0].storageClass | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| ports[0].containerPort | int | `8080` |  |
| ports[0].name | string | `"http"` |  |
| ports[0].protocol | string | `"TCP"` |  |
| readinessProbe.httpGet.path | string | `"/health"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| replicaCount | int | `1` | Default values for testserver. |
| resources | object | `{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"20m","memory":"72Mi"}}` | Minimun values, increase in downstream configs. |
| securityContext | object | `{"runAsNonRoot":true,"runAsUser":1000}` | Should be set to least privileges. |
| service | object | `{"port":80,"targetPort":8080,"type":"ClusterIP"}` | Expose standard Http port |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Configure (cluster-)roles for granulated permissions. |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | If not set and create is true, a name is generated using the fullname template |
| tests.enabled | bool | `false` |  |
| tmpfs.enabled | bool | `true` |  |
| tmpfs.volumes[0].mountPath | string | `"/tmp"` |  |
| tmpfs.volumes[0].name | string | `"tmp"` |  |
| tmpfs.volumes[1].mountPath | string | `"/home/web/instance"` |  |
| tmpfs.volumes[1].name | string | `"instance"` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.3](https://github.com/norwoodj/helm-docs/releases/v1.11.3)