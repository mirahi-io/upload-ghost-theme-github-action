## Example pipeline

```yaml
name: Upload Ghost theme
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Upload Ghost theme
        uses: mirahi-io/upload-ghost-theme-github-action@main
        with:
          ghost_domain: ${{ secrets.GHOST_DOMAIN }}
          ghost_api_key: ${{ secrets.GHOST_API_KEY }}
          file: ${{ secrets.FILE }}
```
