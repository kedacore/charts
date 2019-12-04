```bash
helm package keda
mv keda-*.tgz docs
helm repo index docs --url https://kedacore.github.io/charts
git add .
git commit ...
git push origin master
```