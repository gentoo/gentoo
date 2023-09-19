# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_MODULE=lib/
XORG_MULTILIB=yes
XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="Pthread functions stubs for platforms missing them"
KEYWORDS="~ppc-macos ~x64-macos"

# there is nothing to compile for this package, all its contents are produced by
# configure. the only make job that matters is make install
multilib_src_compile() { true; }
