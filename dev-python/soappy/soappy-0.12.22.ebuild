# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/soappy/soappy-0.12.22.ebuild,v 1.5 2015/05/05 09:38:54 jer Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ssl?,xml"

inherit distutils-r1

MY_PN="SOAPpy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="SOAP Services for Python"
HOMEPAGE="http://pywebsvcs.sourceforge.net/ http://pypi.python.org/pypi/SOAPpy"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc64 ~x86"

IUSE="examples ssl"

RDEPEND="dev-python/wstools[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	ssl? ( dev-python/m2crypto[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

DOCS=( CHANGES.txt README.txt docs/. )

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r bid contrib tools validate
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
