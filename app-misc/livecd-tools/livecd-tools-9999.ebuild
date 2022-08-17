# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/livecd-tools.git"
	inherit git-r3
else
	SRC_URI="https://gitweb.gentoo.org/proj/livecd-tools.git/snapshot/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~sparc ~x86"
fi

DESCRIPTION="Gentoo LiveCD tools for autoconfiguration of hardware"
HOMEPAGE="https://gitweb.gentoo.org/proj/livecd-tools.git/"

SLOT="0"
LICENSE="GPL-2"

RDEPEND="
	dev-util/dialog
	media-sound/alsa-utils
	net-dialup/mingetty
	sys-apps/openrc
	sys-apps/pciutils
"

pkg_setup() {
	ewarn "This package is designed for use on the LiveCD only and will do"
	ewarn "unspeakably horrible and unexpected things on a normal system."
	ewarn "YOU HAVE BEEN WARNED!!!"

	CONFIG_CHECK="~SND_PROC_FS"
	linux-info_pkg_setup
}

src_install() {
	doconfd conf.d/*
	doinitd init.d/*
	dosbin net-setup
	into /
	dosbin livecd-functions.sh
}
