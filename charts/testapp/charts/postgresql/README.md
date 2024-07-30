# postgresql

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 15.4](https://img.shields.io/badge/AppVersion-15.4-informational?style=flat-square)

Umbrella chart for bitnami postgresql

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | 15.5.7 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| postgresql.auth.existingSecret | string | `""` |  |
| postgresql.auth.secretKeys.adminPasswordKey | string | `"postgres-password"` |  |
| postgresql.auth.secretKeys.replicationPasswordKey | string | `"replication-password"` |  |
| postgresql.auth.secretKeys.userPasswordKey | string | `"password"` |  |
| postgresql.backup.cronjob.annotations."backup.velero.io/backup-volumes" | string | `"datadir"` |  |
| postgresql.backup.cronjob.command[0] | string | `"/bin/sh"` |  |
| postgresql.backup.cronjob.command[1] | string | `"-c"` |  |
| postgresql.backup.cronjob.command[2] | string | `"echo \"Starting PostgreSql dump of all databases.\"\npg_dumpall --clean --if-exists --load-via-partition-root --quote-all-identifiers \\\n  --no-password --file=${PGDUMP_DIR}/pg_dumpall-$(date '+%Y-%m-%d-%H-%M').pgdump\necho \"PostgreSql dump finished, taking a nap.\"\nsleep 10800\necho \"Terminate job after 3h waiting for Velero\"\n"` |  |
| postgresql.backup.cronjob.concurrencyPolicy | string | `"Allow"` |  |
| postgresql.backup.cronjob.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| postgresql.backup.cronjob.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| postgresql.backup.cronjob.containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| postgresql.backup.cronjob.containerSecurityContext.runAsGroup | int | `0` |  |
| postgresql.backup.cronjob.containerSecurityContext.runAsNonRoot | bool | `true` |  |
| postgresql.backup.cronjob.containerSecurityContext.runAsUser | int | `1001` |  |
| postgresql.backup.cronjob.containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| postgresql.backup.cronjob.failedJobsHistoryLimit | int | `1` |  |
| postgresql.backup.cronjob.labels | object | `{}` |  |
| postgresql.backup.cronjob.nodeSelector | object | `{}` |  |
| postgresql.backup.cronjob.podSecurityContext.enabled | bool | `true` |  |
| postgresql.backup.cronjob.podSecurityContext.fsGroup | int | `1001` |  |
| postgresql.backup.cronjob.restartPolicy | string | `"OnFailure"` |  |
| postgresql.backup.cronjob.schedule | string | `"0 23 * * *"` |  |
| postgresql.backup.cronjob.startingDeadlineSeconds | string | `"600"` |  |
| postgresql.backup.cronjob.storage.accessModes[0] | string | `"ReadWriteMany"` |  |
| postgresql.backup.cronjob.storage.annotations | object | `{}` |  |
| postgresql.backup.cronjob.storage.existingClaim | string | `""` |  |
| postgresql.backup.cronjob.storage.mountPath | string | `"/backup/pgdump"` |  |
| postgresql.backup.cronjob.storage.resourcePolicy | string | `""` |  |
| postgresql.backup.cronjob.storage.size | string | `"8Gi"` |  |
| postgresql.backup.cronjob.storage.storageClass | string | `""` |  |
| postgresql.backup.cronjob.storage.subPath | string | `""` |  |
| postgresql.backup.cronjob.storage.volumeClaimTemplates.selector | object | `{}` |  |
| postgresql.backup.cronjob.successfulJobsHistoryLimit | int | `3` |  |
| postgresql.backup.cronjob.timezone | string | `"CET"` |  |
| postgresql.backup.cronjob.ttlSecondsAfterFinished | string | `"86400"` |  |
| postgresql.backup.enabled | bool | `false` |  |
| postgresql.commonLabels | object | `{}` |  |
| postgresql.global.storageClass | string | `"standard-csi"` |  |
| postgresql.image.registry | string | `"docker.io"` |  |
| postgresql.image.tag | string | `"15.6.0-debian-12-r20"` |  |
| postgresql.metrics.enabled | bool | `false` |  |
| postgresql.primary.initdb.password | string | `""` |  |
| postgresql.primary.initdb.scripts | object | `{}` |  |
| postgresql.primary.initdb.scriptsConfigMap | string | `""` |  |
| postgresql.primary.initdb.scriptsSecret | string | `""` |  |
| postgresql.primary.initdb.user | string | `""` |  |
| postgresql.primary.persistence.size | string | `"8Gi"` |  |
| postgresql.primary.podAnnotations."backup.velero.io/backup-volumes" | string | `"data"` |  |
| postgresql.primary.resources | object | `{}` |  |
| postgresql.primary.resourcesPreset | string | `"small"` |  |
| postgresql.restore.enabled | bool | `false` |  |
| postgresql.save_to_s3.enabled | bool | `false` |  |
| postgresql.save_to_s3.image.name | string | `"minio/mc"` |  |
| postgresql.save_to_s3.image.tag | string | `"RELEASE.2024-07-08T20-59-24Z"` |  |
| postgresql.save_to_s3.resources.limits.cpu | string | `"150m"` |  |
| postgresql.save_to_s3.resources.limits.ephemeral-storage | string | `"1Gi"` |  |
| postgresql.save_to_s3.resources.limits.memory | string | `"192Mi"` |  |
| postgresql.save_to_s3.resources.requests.cpu | string | `"100m"` |  |
| postgresql.save_to_s3.resources.requests.ephemeral-storage | string | `"50Mi"` |  |
| postgresql.save_to_s3.resources.requests.memory | string | `"128Mi"` |  |
| postgresql.save_to_s3.schedule | string | `"0 8 * * *"` |  |
| postgresql.save_to_s3.secretName | string | `"pro-minio-for-backups"` |  |
| postgresql.save_to_s3.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| postgresql.save_to_s3.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| postgresql.save_to_s3.securityContext.privileged | bool | `false` |  |
| postgresql.save_to_s3.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| postgresql.save_to_s3.securityContext.runAsNonRoot | bool | `true` |  |
| postgresql.save_to_s3.securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| postgresql.sealedSecrets.enabled | bool | `false` |  |
| postgresql.tls.enabled | bool | `false` |  |
