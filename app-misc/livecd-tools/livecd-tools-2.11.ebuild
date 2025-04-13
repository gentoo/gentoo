# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info

KEYMAP_VER=v1.0.0

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://anongit.gentoo.org/proj/livecd-tools.git"
	inherit git-r3
else
	SRC_URI="https://gitweb.gentoo.org/proj/livecd-tools.git/snapshot/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm64 hppa ~loong ~mips ppc ppc64 sparc x86"
fi

DESCRIPTION="Gentoo LiveCD tools for autoconfiguration of hardware"
HOMEPAGE="https://gitweb.gentoo.org/proj/livecd-tools.git/"
LICENSE="GPL-2"
SLOT="0"

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
	# Add the keymap hook for dracut
	insinto /usr/lib/dracut/modules.d
	doins -r dracut/90dokeymap
	insinto /lib
	doins -r lib/keymaps
	# Copying Genkernel's hack to create /mnt/gentoo until a cleaner
	# solution is created.
	keepdir /mnt/gentoo
}
