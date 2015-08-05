# t510
My modifications to make a HP t510 thinclient running Thinpro more usable.

## Installation
> Many changes require `fsunlock` to unlock the filesystem. Afterwards you can re-lock it by `fslock`.

To install, simply copy the files in `openbox` to `/writable/home/user/.config/openbox/` and in `bin` to `/writable/home/user/bin/`. 

Now replace your `menu.xml` and `rc.xml` with `menu.xml.custom` and `rc.xml.custom`.

Create folders if necessary. Run `openbox --reconfigure` from a terminal (you have access to xterm in admin-mode) to make openbox recognize the changes.
