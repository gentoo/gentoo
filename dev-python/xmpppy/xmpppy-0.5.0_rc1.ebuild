# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

MY_P="${P/_/-}"

DESCRIPTION="Python library providing easy scripting with Jabber"
HOMEPAGE="http://xmpppy.sourceforge.net/"
SRC_URI="mirror://sourceforge/xmpppy/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ~ppc ~ppc64 x86"
IUSE="doc"

RDEPEND="|| (
		dev-python/dnspython:0
		dev-python/pydns
	)"
DEPEND="${RDEPEND}
	dev-python/setuptools"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="xmpp"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${PN}-hashlib_ssl_deprecation.patch"
}

src_install() {
	distutils_src_install
	use doc && dohtml -A py -r doc/.
}
