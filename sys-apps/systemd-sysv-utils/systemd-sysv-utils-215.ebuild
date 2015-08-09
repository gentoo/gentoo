# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P=systemd-${PV}

DESCRIPTION="sysvinit compatibility symlinks and manpages"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/systemd"
SRC_URI="http://www.freedesktop.org/software/systemd/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE=""

# new enough util-linux to have tools that were provided by sysvinit
# earlier.
RDEPEND="!sys-apps/sysvinit
	>=sys-apps/systemd-201
	>=sys-apps/util-linux-2.24.1-r2"

S=${WORKDIR}/${MY_P}/man

src_install() {
	: ${ROOTPREFIX=/usr}
	for app in halt poweroff reboot runlevel shutdown telinit; do
		doman ${app}.8
		dosym "..${ROOTPREFIX}/bin/systemctl" /sbin/${app}
	done

	newman init.1 init.8
	dosym "..${ROOTPREFIX}/lib/systemd/systemd" /sbin/init
}
