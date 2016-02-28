# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit eutils autotools-multilib

DATE="${PV##*_p}"
MY_PV="${PV%%_*}"
MY_P="${PN}-${DATE}-${MY_PV}"

DESCRIPTION="Port of the NetBSD editline library"
HOMEPAGE="http://thrysoee.dk/editline"
SRC_URI="http://thrysoee.dk/editline/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	sys-libs/ncurses:0="

DEPEND="
	${RDEPEND}
	sys-devel/libtool
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	autotools-multilib_src_prepare
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-widec
		$(use_enable examples)
	)

	autotools-utils_src_configure
}

src_compile() {
	autotools-multilib_src_compile
}

multilib_src_install() {
	emake install DESTDIR="${D}"
}

src_install() {
	autotools-multilib_src_install
}
