# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=$(ver_cut 2-)
MY_PV=${MY_PV/beta/}

DESCRIPTION="High-resolution textures for Quake 2"
HOMEPAGE="http://jdolan.tastyspleen.net/"
SRC_URI="http://jdolan.tastyspleen.net/pak${MY_PV}.zip"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="bindist mirror"

BDEPEND="app-arch/unzip"

src_install() {
	insinto /usr/share/quake2/baseq2
	doins *.pak
	dodoc README
}

pkg_postinst() {
	elog "Use a recent Quake 2 client to take advantage of"
	elog "these textures, e.g. qudos or quake2-icculus."
	echo
}
