
WARNING - the 23.0 profile tree is still experimental.

Recommended upgrade path:
(please make sure to read the annotations like [*] if applicable)

default/linux/amd64/17.1
==> default/linux/amd64/23.0/split-usr

default/linux/amd64/17.1/selinux
==> default/linux/amd64/23.0/split-usr/hardened/selinux [%]

default/linux/amd64/17.1/hardened
==> default/linux/amd64/23.0/split-usr/hardened

default/linux/amd64/17.1/hardened/selinux
==> default/linux/amd64/23.0/split-usr/hardened/selinux

default/linux/amd64/17.1/desktop
==> default/linux/amd64/23.0/split-usr/desktop

default/linux/amd64/17.1/desktop/gnome
==> default/linux/amd64/23.0/split-usr/desktop/gnome

default/linux/amd64/17.1/desktop/gnome/systemd
==> default/linux/amd64/23.0/desktop/gnome/systemd  [*]

default/linux/amd64/17.1/desktop/gnome/systemd/merged-usr
==> default/linux/amd64/23.0/desktop/gnome/systemd

default/linux/amd64/17.1/desktop/plasma
==> default/linux/amd64/23.0/split-usr/desktop/plasma

default/linux/amd64/17.1/desktop/plasma/systemd
==> default/linux/amd64/23.0/desktop/plasma/systemd  [*]

default/linux/amd64/17.1/desktop/plasma/systemd/merged-usr
==> default/linux/amd64/23.0/desktop/plasma/systemd

default/linux/amd64/17.1/desktop/systemd
==> default/linux/amd64/23.0/desktop/systemd  [*]

default/linux/amd64/17.1/desktop/systemd/merged-usr
==> default/linux/amd64/23.0/desktop/systemd

default/linux/amd64/17.1/developer
==> default/linux/amd64/23.0  [*,#]

default/linux/amd64/17.1/no-multilib
==> default/linux/amd64/23.0/split-usr/no-multilib

default/linux/amd64/17.1/no-multilib/hardened
==> default/linux/amd64/23.0/split-usr/no-multilib/hardened

default/linux/amd64/17.1/no-multilib/hardened/selinux
==> default/linux/amd64/23.0/split-usr/no-multilib/hardened/selinux

default/linux/amd64/17.1/no-multilib/systemd
==> default/linux/amd64/23.0/no-multilib/systemd  [*]

default/linux/amd64/17.1/no-multilib/systemd/merged-usr
==> default/linux/amd64/23.0/no-multilib/systemd

default/linux/amd64/17.1/no-multilib/systemd/selinux
==> default/linux/amd64/23.0/no-multilib/hardened/selinux/systemd  [*,%]

default/linux/amd64/17.1/no-multilib/systemd/selinux/merged-usr
==> default/linux/amd64/23.0/no-multilib/hardened/selinux/systemd  [%]

default/linux/amd64/17.1/systemd
==> default/linux/amd64/23.0/systemd  [*]

default/linux/amd64/17.1/systemd/merged-usr
==> default/linux/amd64/23.0/systemd

default/linux/amd64/17.1/systemd/selinux
==> default/linux/amd64/23.0/hardened/selinux/systemd  [*,%]

default/linux/amd64/17.1/systemd/selinux/merged-usr
==> default/linux/amd64/23.0/hardened/selinux/systemd  [%]

default/linux/amd64/17.1/clang
==> default/linux/amd64/23.0/split-usr/llvm

default/linux/amd64/17.1/systemd/clang
==> default/linux/amd64/23.0/llvm/systemd  [*]

default/linux/amd64/17.1/systemd/clang/merged-usr
==> default/linux/amd64/23.0/llvm/systemd

default/linux/amd64/17.0/x32
==> default/linux/amd64/23.0/split-usr/x32

default/linux/amd64/17.0/x32/systemd
==> default/linux/amd64/23.0/x32/systemd  [*]

default/linux/amd64/17.0/x32/systemd/merged-usr
==> default/linux/amd64/23.0/x32/systemd

default/linux/amd64/17.0/musl
==> default/linux/amd64/23.0/split-usr/musl

default/linux/amd64/17.0/musl/clang
==> default/linux/amd64/23.0/split-usr/musl/llvm

default/linux/amd64/17.0/musl/hardened
==> default/linux/amd64/23.0/split-usr/musl/hardened

default/linux/amd64/17.0/musl/hardened/selinux
==> default/linux/amd64/23.0/split-usr/musl/hardened/selinux

default/linux/amd64/17.0/no-multilib/prefix/kernel-3.2+
==> default/linux/amd64/23.0/split-usr/no-multilib/prefix/kernel-3.2+  [&]

default/linux/amd64/17.0/no-multilib/prefix/kernel-2.6.32+
==> default/linux/amd64/23.0/split-usr/no-multilib/prefix/kernel-2.6.32+  [&]

default/linux/amd64/17.0/no-multilib/prefix/kernel-2.6.16+
==> default/linux/amd64/23.0/split-usr/no-multilib/prefix/kernel-2.6.16+  [&]

default/linux/amd64/17.1/no-multilib/prefix/kernel-3.2+
==> default/linux/amd64/23.0/split-usr/no-multilib/prefix/kernel-3.2+

default/linux/amd64/17.1/no-multilib/prefix/kernel-2.6.32+
==> default/linux/amd64/23.0/split-usr/no-multilib/prefix/kernel-2.6.32+

default/linux/amd64/17.1/no-multilib/prefix/kernel-2.6.16+
==> default/linux/amd64/23.0/split-usr/no-multilib/prefix/kernel-2.6.16+



[*] This upgrade switches from split-usr to merged-usr layout since
    the corresponding profile is not available anymore.
    Please follow the migration guide.

[#] The developer profiles are gone. Please migrate eventual settings
    to your make.conf.

[&] You will have to do the symlink migration from 17.0 to 17.1 first.

[%] There are no standalone selinux profiles anymore, only hardened/selinux.
