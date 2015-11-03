# t510
My modifications to make a HP t510 thinclient running Thinpro more usable.

## Automatic Installation
> Many changes require `fsunlock` to unlock the filesystem. Afterwards you can re-lock it by `fslock`.

> You have to establish an internet connection to run the automatic install

To install use the install preinstall script

```
wget https://github.com/darkblinded/t510/raw/master/predeploy.sh
./predeploy.sh
```

If everything went correctly you can now start the install script.

```
/writable/home/user/t510/install.sh
```
