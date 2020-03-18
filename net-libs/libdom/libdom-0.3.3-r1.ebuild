# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="implementation of the W3C DOM, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libdom/"
SRC_URI="https://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~m68k-mint"
IUSE="expat test xml"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libparserutils-0.2.1-r1
	>=dev-libs/libwapcaplet-0.3.0
	>=net-libs/libhubbub-0.3.1-r1
	xml? (
		expat? ( >=dev-libs/expat-2.1.0-r3 )
		!expat? ( >=dev-libs/libxml2-2.9.1-r4 )
	)"
DEPEND="${RDEPEND}
	dev-util/netsurf-buildsystem
	virtual/pkgconfig
	test? (
		dev-perl/XML-XPath
		dev-perl/libxml-perl
		dev-perl/Switch
	)"

REQUIRED_USE="test? ( xml )"

_emake() {
	source /usr/share/netsurf-buildsystem/gentoo-helpers.sh
	netsurf_define_makeconf
	emake "${NETSURF_MAKECONF[@]}" COMPONENT_TYPE=lib-shared \
		WITH_EXPAT_BINDING=$(usex xml $(usex expat yes no) no) \
		WITH_LIBXML_BINDING=$(usex xml $(usex expat no yes) no) \
		$@
}

src_compile() {
	_emake
}

src_test() {
	_emake test
}

src_install() {
	_emake DESTDIR="${ED}" install
}
