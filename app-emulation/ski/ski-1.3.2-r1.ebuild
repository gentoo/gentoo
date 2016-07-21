# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools eutils

DESCRIPTION="ia64 instruction set simulator"
HOMEPAGE="http://ski.sourceforge.net/ http://www.gelato.unsw.edu.au/IA64wiki/SkiSimulator"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gtk motif"

RDEPEND="dev-libs/libltdl:0
	sys-libs/ncurses
	virtual/libelf
	gtk? (
		gnome-base/libglade:2.0
		gnome-base/libgnomeui
		x11-libs/gtk+:2
	)
	motif? ( x11-libs/motif )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	dev-util/gperf"

PATCHES=(
	"${FILESDIR}"/${P}-syscall-linux-includes.patch
	"${FILESDIR}"/${P}-remove-hayes.patch
	"${FILESDIR}"/${P}-no-local-ltdl.patch
	"${FILESDIR}"/${P}-AC_C_BIGENDIAN.patch
	"${FILESDIR}"/${P}-configure-withval.patch
	"${FILESDIR}"/${P}-binutils.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"

	rm -rf libltdl src/ltdl.[ch] macros/ltdl.m4

	AT_M4DIR="macros" eautoreconf
}

src_configure() {
	econf \
		--without-included-ltdl \
		$(use_with gtk) \
		$(use_with motif x11)
}
