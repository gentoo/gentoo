# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

MY_P="${P/_/-}"

DESCRIPTION="Python library providing easy scripting with Jabber"
HOMEPAGE="http://xmpppy.sourceforge.net/"
SRC_URI="mirror://sourceforge/xmpppy/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ~ppc ~ppc64 x86"
IUSE="doc"

RDEPEND="
	|| (
		virtual/python-dnspython[${PYTHON_USEDEP}]
		dev-python/pydns:2[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-hashlib_ssl_deprecation.patch"
	"${FILESDIR}/${P}-ssl_fields.patch"
)

python_install_all() {
	use doc && HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}
