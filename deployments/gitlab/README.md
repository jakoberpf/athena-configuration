# gitlab

```bash
kubectl apply -k .
helm upgrade gitlab gitlab/gitlab --version=5.10.2 --values=values.yaml --install
```