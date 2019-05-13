You may wonder what's this `Dockerfile` for. I have tested the Windows Server 2019 insider 17744 build
to see if I can run the `test.ps1` script that checks all packer templates with `packer validate` in a Windows container.

```
docker build -t packervalidate .
```

If the Docker image can be built then all packer templates have no errors.
