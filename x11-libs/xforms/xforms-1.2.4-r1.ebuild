# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="${P/-/_}"

DESCRIPTION="A graphical user interface toolkit for X"
HOMEPAGE="http://xforms-toolkit.org/"
SRC_URI="https://dev.gentoo.org/~monsieurp/packages/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc opengl"

RDEPEND="
	virtual/jpeg:0=
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXpm
	opengl? ( virtual/opengl )"

DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

DOCS=( ChangeLog README )

src_prepare() {
	default
	AT_M4DIR=config eautoreconf
}

src_configure() {
	econf \
		$(use_enable doc docs) \
		$(use_enable opengl gl) \
		--disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
