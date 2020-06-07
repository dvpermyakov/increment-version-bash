# Increment version script

This script allows you to automatically incement a version of your library or project. 
You need to create a file **version.txt** inside your repository.
Format of string inside file is (major version).(minor version).(patch version):
```
1.0.3
```

The script increases only a patch version. You can do this by running the commands in a terminal:
```Bash
export REPOSITORY=https://github.com/dvpermyakov/increment-version-bash
./increment.sh -r $REPOSITORY -b development -m master -f version.txt
```

Flags:
1. **-r**: url to your repository where you created **version.txt**
2. **-b**: current branch where you would like to increment version
3. **-m**: default branch where script can get a last valid version. The version of current branch will be increased if default branch has version greater or equal
4. **-v**: file where version is kept

This script is helpful inside CI script:
```Yaml
- run:
    name: Increase version
    command: |
      git config --global user.name $GIT_USERNAME
      git config --global user.email $GIT_USEREMAIL
      git clone https://github.com/dvpermyakov/increment-version-bash.git
      cd increment-version-bash/
      chmod u+x ./increment.sh
      ./increment.sh -r $CIRCLE_REPOSITORY -b $CIRCLE_BRANCH -m master -f version.txt
```
