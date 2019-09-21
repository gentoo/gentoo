# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit autotools

MY_P=GUIlib-${PV}

DESCRIPTION="Simple widget set for SDL"
SRC_URI="https://www.libsdl.org/projects/GUIlib/src/${MY_P}.tar.gz"
HOMEPAGE="https://www.libsdl.org/projects/GUIlib/"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86"
IUSE="static-libs"

RDEPEND=">=media-libs/libsdl-1.0.1"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i -e '/^noinst_PROGRAMS/,$d' Makefile.am

	rm -f *.m4
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default

	use static-libs || find "${ED}" -name '*.la' -exec rm {} +
}
