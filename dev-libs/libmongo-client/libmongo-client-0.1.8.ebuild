# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit autotools

DESCRIPTION="The alternative C driver for MongoDB"
HOMEPAGE="https://github.com/algernon/libmongo-client"
SRC_URI="https://github.com/algernon/${PN}/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/0.5.0"
KEYWORDS="~amd64 ~arm ~hppa ~x86"
IUSE="doc"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"
RDEPEND="dev-libs/glib"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	default

	eautoreconf
}

src_compile() {
	default

	use doc && emake DESTDIR="${D%/}" doxygen
}

src_install() {
	use doc && local HTML_DOCS=( docs/html/. )
	default

	find "${ED}"usr/lib* -name '*.la' -delete || die
}
