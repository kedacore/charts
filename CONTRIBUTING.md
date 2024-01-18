# Contributing to KEDA Helm Charts

Thanks for helping making KEDA better!

## Shipping a new version

> ⚠️ New Helm chart versions are only released in conjunction with KEDA Core or hotfixes, individual PRs do not have to perform these steps

You can easily release a new Helm chart version:

1. Update the version of the Helm chart in [Chart.yaml](keda/Chart.yaml).
2. Update Warning message about Kubernetes compatibility in [NOTES.txt](keda/templates/NOTES.txt).
3. Re-generate the Helm chart docs ([learn more](#documentation))
4. Package the Helm chart
    - For KEDA:
        ```shell
        $ helm package keda --destination docs
        Successfully packaged chart and saved it to: docs/keda-2.5.0.tgz
        ```
    - For HTTP add-on:
        ```shell
        $ helm package http-add-on --destination docs
        Successfully packaged chart and saved it to: docs/keda-add-ons-http-0.2.0.tgz
        ```
    - For Azure Cosmos DB external scaler:
        ```shell
        $ helm package external-scaler-azure-cosmos-db --destination docs
        Successfully packaged chart and saved it to: docs/external-scaler-azure-cosmos-db-0.1.0.tgz
        ```
5. Re-index the Helm repo to add our new version:
    ```shell
    $ helm repo index docs --url https://kedacore.github.io/charts
    ```
6. Update the version in the "Browse all our Helm charts" section of our README.md
7. Commit changes:
    ```shell
    git add .
    git commit -sm "Packaged new Helm chart version"
    git push origin chart-release
    ```
8. Create a pull request with our new Helm index.
9. Create a GitHub release for your new Helm chart version by using the following template.
    - Make sure to list the changes to our Helm chart which are tracked in the [KEDA Core vNext](https://github.com/kedacore/charts/milestone/10) milestone
    - Instead of listing all KEDA core changes, simply refer to our release notes on the other repo (see template)

> *Chart: {{Chart Version}} | App: {{App Name}}*
> {{Description about the Helm chart}}
>
> ## TL;DR
>
> ```shell
> helm repo add kedacore https://kedacore.github.io/charts
> helm repo update
> helm install keda kedacore/keda --version {{Chart Version}} -n keda --create-namespace
> ```
>
> ## What is new?
>
> ### Features
>
> - Support for KEDA v{version} ([release notes]({{URL to release}}))
> - {{List new features}}
>
> ### Fixes / Changes
>
> - {{List fixes}}
>
> ### Breaking Changes
>
> - {{List breaking changes}}
>
> ### Removal
>
> - {{List removed features}}

10. Create a new milestone called `KEDA Core v{version}`
11. Move the closed items from `KEDA Core vNext` to the new milestone and close it

## Developer Certificate of Origin: Signing your work

### Every commit needs to be signed

The Developer Certificate of Origin (DCO) is a lightweight way for contributors to certify that they wrote or otherwise have the right to submit the code they are contributing to the project. Here is the full text of the DCO, reformatted for readability:

```text
By making a contribution to this project, I certify that:

    (a) The contribution was created in whole or in part by me and I have the right to submit it under the open source license indicated in the file; or

    (b) The contribution is based upon previous work that, to the best of my knowledge, is covered under an appropriate open source license and I have the right under that license to submit that work with modifications, whether created in whole or in part by me, under the same open source license (unless I am permitted to submit under a different license), as indicated in the file; or

    (c) The contribution was provided directly to me by some other person who certified (a), (b) or (c) and I have not modified it.

    (d) I understand and agree that this project and the contribution are public and that a record of the contribution (including all personal information I submit with it, including my sign-off) is maintained indefinitely and may be redistributed consistent with this project or the open source license(s) involved.
```

Contributors sign-off that they adhere to these requirements by adding a `Signed-off-by` line to commit messages.

```text
This is my commit message

Signed-off-by: Random J Developer <random@developer.example.org>
```

Git even has a `-s` command line option to append this automatically to your commit message:

```shell
$ git commit -s -m 'This is my commit message'
```

Each Pull Request is checked  whether or not commits in a Pull Request do contain a valid Signed-off-by line.

### I didn't sign my commit, now what?!

No worries - You can easily replay your changes, sign them and force push them!

```shell
git checkout <branch-name>
git reset $(git merge-base main <branch-name>)
git add -A
git commit -sm "one commit on <branch-name>"
git push --force
```

## Documentation

The documentation for each chart is generated with [helm-docs](https://github.com/norwoodj/helm-docs). This way we can ensure that values are consistent with the chart documentation.

To update a charts documentation, please run the following command:

```shell
$ helm-docs
INFO[2023-05-16T23:18:14+02:00] Found Chart directories [.]
INFO[2023-05-16T23:18:14+02:00] Generating README Documentation for chart .

# or with a docker command:

$ docker run -v "$PWD:/helm-docs" -u $(id -u) jnorwood/helm-docs:latest
time="2023-05-16T21:22:00Z" level=info msg="Found Chart directories [.]"
time="2023-05-16T21:22:00Z" level=info msg="Generating README Documentation for chart ."
```

> **Note**
> When creating your own `README.md.gotmpl`, don't forget to add it to your `.helmignore` file.
