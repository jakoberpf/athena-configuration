# gitlab

```bash
kubectl apply -k .
kubens gitlab
helm upgrade gitlab gitlab/gitlab --version=5.10.2 --values=values.yaml --install
```