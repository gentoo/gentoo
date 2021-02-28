# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1

DESCRIPTION="highly flexible status line for the i3 window manager"
HOMEPAGE="https://github.com/vivien/i3blocks"
SRC_URI="https://github.com/vivien/i3blocks/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="+contrib"

PDEPEND="contrib? ( x11-misc/i3blocks-contrib )"

PATCHES=( "${FILESDIR}"/${PN}-disable-bash-completion.patch )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	newbashcomp bash-completion ${PN}
}
