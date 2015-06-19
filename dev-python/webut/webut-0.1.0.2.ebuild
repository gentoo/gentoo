# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/webut/webut-0.1.0.2.ebuild,v 1.14 2014/12/12 23:23:24 mgorny Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils versionator

MY_P=${PN}_$(replace_version_separator 2 '-')

DESCRIPTION="Miscellaneous utilities for nevow and twisted.web programming"
HOMEPAGE="http://www.inoi.fi/open/trac/webut"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE="examples"

RDEPEND=">=dev-python/nevow-0.9.18
	>=dev-python/twisted-core-2
	>=dev-python/zope-interface-3.0.1"
DEPEND="${RDEPEND}"
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${PN}-$(get_version_component_range 1-2)"

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi

	rm -rf "${D}/examples"
}
