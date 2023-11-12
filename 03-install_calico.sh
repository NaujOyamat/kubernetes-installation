# Official Calico documentation :: https://docs.projectcalico.org

curl -O -L  https://github.com/projectcalico/calicoctl/releases/download/v3.21.5/calicoctl-linux-amd64
chmod +x calicoctl-linux-amd64
sudo mv calicoctl-linux-amd64 /usr/local/bin/calicoctl

vi calicoctl.cfg

apiVersion: projectcalico.org/v3
kind: CalicoAPIConfig
metadata:
spec:
  datastoreType: "kubernetes"
  kubeconfig: "/home/rik/.kube/config"


sudo mkdir -p /etc/calico
sudo cp calicoctl.cfg /etc/calico


kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.3/manifests/tigera-operator.yaml

curl -O -L https://raw.githubusercontent.com/projectcalico/calico/v3.26.3/manifests/custom-resources.yaml

apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:
  # Configures Calico networking.
  calicoNetwork:
    # Note: The ipPools section cannot be modified post-install.
    ipPools:
    - blockSize: 26
      cidr: 10.10.0.0/24
      encapsulation: None
      natOutgoing: Enabled
      nodeSelector: all()


kubectl create -f custom-resources.yaml

kubectl get pods -n calico-system

# To verify if your cluster is working fine or not with Calico

calicoctl version

sudo calicoctl node status

calicoctl get ippools default-ipv4-ippool -o yaml --allow-version-mismatch

calicoctl ipam show --allow-version-mismatch

calicoctl ipam show --show-blocks --allow-version-mismatch
