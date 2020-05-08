# Generating the Data Encryption Config and Key
Kubernetes stores a variety of data including cluster state, application configurations, and secrets.  
Kubernetes supports the ability to encrypt cluster data at rest.

## The Encryption Key.
Generate an encryption key:

    ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
    
## The Encryption Config File.
Create the encryption-config.yaml encryption config file:

    cat > encryption-config.yaml <<EOF
    kind: EncryptionConfig
    apiVersion: v1
    resources:
      - resources:
          - secrets
        providers:
          - aescbc:
              keys:
                - name: key1
                  secret: ${ENCRYPTION_KEY}
          - identity: {}
    EOF
    
Next: [Bootstrapping the etcd Cluster](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/07-Bootstraping-etcd.md)
