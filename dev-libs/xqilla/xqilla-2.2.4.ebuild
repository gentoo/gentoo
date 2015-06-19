# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xqilla/xqilla-2.2.4.ebuild,v 1.4 2014/08/10 20:40:44 slyfox Exp $

EAPI="2"
inherit autotools base

MY_P="XQilla-${PV}"

DESCRIPTION="An XQuery and XPath 2 library and command line utility written in C++"
HOMEPAGE="http://xqilla.sourceforge.net/HomePage"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples faxpp htmltidy"

# XQilla bundles two libraries:
# - mapm, heavily patched
# - yajl, moderately patched
# There's currently no way to unbundle those

RDEPEND=">=dev-libs/xerces-c-3.1.0
	faxpp? ( dev-libs/faxpp )
	htmltidy? ( app-text/htmltidy )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/${PV}-respect-ldflags-no-rpath.patch"
	"${FILESDIR}/${P}-gcc46.patch"
	"${FILESDIR}/${P}-gcc47.patch"
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		--with-xerces=/usr \
		$(use_enable debug) \
		$(use_with htmltidy tidy) \
		$(use_with faxpp faxpp /usr)
}

src_compile() {
	default

	if use doc; then
		emake docs || die "emake docs failed"
		emake devdocs || die "emake devdocs failed"
	fi
}

src_install () {
	emake DESTDIR="${D}" install || die "emake docs failed"

	dodoc ChangeLog TODO

	if use doc; then
		cd docs
		dohtml -r dev-api dom3-api simple-api
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${S}"/src/samples/*
	fi
}
