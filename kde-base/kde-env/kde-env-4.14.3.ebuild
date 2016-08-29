# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_REQUIRED="never"
KDE_REQUIRED="never"
inherit kde4-base

DESCRIPTION="Environment setting required for all KDE4 apps to run"
SRC_URI=""
ESVN_REPO_URI=""

KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE=""

S=${WORKDIR}

src_unpack() {
	:
}

src_prepare() {
	:
}

src_install() {
	# number goes down with version
	newenvd - 43kdepaths <<EOF
CONFIG_PROTECT="/usr/share/config"
#KDE_IS_PRELINKED=1
EOF

	# Properly place xinitrc.d file that exports XDG_MENU_PREFIX to env
	exeinto /etc/X11/xinit/xinitrc.d/
	newexe - 11-xdg-menu-kde-4 <<EOF
#!/bin/sh

if [ -z "\${XDG_MENU_PREFIX}" ] && [ "\${DESKTOP_SESSION}" = "KDE-4" ]; then
	export XDG_MENU_PREFIX="kde-4-"
fi
EOF
}

pkg_preinst() {
	:
}

src_test() {
	:
}
