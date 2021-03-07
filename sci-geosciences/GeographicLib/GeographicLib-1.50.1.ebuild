# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C++ classes for performing conversions between geographic coordinates"
HOMEPAGE="https://geographiclib.sourceforge.io/"
SRC_URI="mirror://sourceforge/geographiclib/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/19"
KEYWORDS="~amd64 ~arm"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	doc? ( >=app-doc/doxygen-1.8.7 )
"

src_configure() {
	econf \
		--disable-static
	# Automagic deps..
	sed -e "s/SUBDIRS =.*$/SUBDIRS = src man tools $(usex doc doc "") include cmake/" -i Makefile || die
}

src_install() {
	default
	find "${D}" -name "*.la" -delete || die
}
