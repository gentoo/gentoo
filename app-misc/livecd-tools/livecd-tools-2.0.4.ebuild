# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/livecd-tools/livecd-tools-2.0.4.ebuild,v 1.4 2015/04/25 16:09:41 floppym Exp $

EAPI=5

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/livecd-tools.git"
	inherit git-2
else
	SRC_URI="https://dev.gentoo.org/~zerochaos/distfiles/${P}.tar.xz"
	KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
fi

inherit eutils

DESCRIPTION="Gentoo LiveCD tools for autoconfiguration of hardware"
HOMEPAGE="http://wolf31o2.org/projects/livecd-tools"

SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="dev-util/dialog
	net-dialup/mingetty
	>=sys-apps/baselayout-2
	>=sys-apps/openrc-0.8.2-r1
	sys-apps/pciutils
	sys-apps/gawk
	sys-apps/sed"

pkg_setup() {
		ewarn "This package is designed for use on the LiveCD only and will do"
		ewarn "unspeakably horrible and unexpected things on a normal system."
		ewarn "YOU HAVE BEEN WARNED!!!"
}

src_install() {
	doconfd conf.d/*
	doinitd init.d/*
	dosbin net-setup
	into /
	dosbin livecd-functions.sh
}
