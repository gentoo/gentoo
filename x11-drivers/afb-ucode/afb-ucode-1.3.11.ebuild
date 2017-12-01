# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Binary blob microcode for Elite3D framebuffers, required by xf86-video-sunffb"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	http://dlc.sun.com/osol/sparc-gfx/downloads/${PN}.tar.bz2
	mirror://gentoo/${PN}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* sparc"
IUSE=""

RDEPEND="x11-misc/afbinit"

S="${WORKDIR}/${PN}"

src_install() {
	dolib.a afb.ucode
}
