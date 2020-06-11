```bash
helm package keda
mv keda-*.tgz docs
helm repo index docs --url https://kedacore.github.io/charts
git add .
git commit -sm "Packaged new Helm chart version"
git push origin master
```