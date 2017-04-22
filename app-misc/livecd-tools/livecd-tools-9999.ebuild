# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/livecd-tools.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~williamh/dist/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
fi

inherit eutils

DESCRIPTION="Gentoo LiveCD tools for autoconfiguration of hardware"
HOMEPAGE="https://www.gentoo.org"

SLOT="0"
LICENSE="GPL-2"

RDEPEND="
	>=sys-apps/baselayout-2
	>=sys-apps/openrc-0.8.2-r1
	dev-util/dialog
	net-dialup/mingetty
	sys-apps/gawk
	sys-apps/pciutils
	sys-apps/sed
"

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
