# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 netsurf

DESCRIPTION="implementation of the W3C DOM, written in C"
HOMEPAGE="https://www.netsurf-browser.org/projects/libdom/"

EGIT_REPO_URI="https://git.netsurf-browser.org/${PN}.git"
LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS=""
IUSE="expat test xml"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libparserutils
	dev-libs/libwapcaplet
	net-libs/libhubbub
	xml? (
		expat? ( dev-libs/expat )
		!expat? ( dev-libs/libxml2 )
	)"
DEPEND="${RDEPEND}
	test? (
		dev-perl/XML-XPath
		dev-perl/libxml-perl
		dev-perl/Switch
	)"
BDEPEND="
	dev-util/netsurf-buildsystem
	virtual/pkgconfig"

REQUIRED_USE="test? ( xml )"

_emake() {
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
	_emake DESTDIR="${D}" install
}
