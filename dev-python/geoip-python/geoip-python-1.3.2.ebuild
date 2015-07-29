# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/geoip-python/geoip-python-1.3.2.ebuild,v 1.5 2015/07/29 15:14:02 zlogene Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1

MY_PN="geoip-api-python"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python bindings for GeoIP"
HOMEPAGE="https://github.com/maxmind/geoip-api-python"
SRC_URI="https://github.com/maxmind/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ~sparc ~x86 ~x86-fbsd"
IUSE="examples test"

RDEPEND=">=dev-libs/geoip-1.4.8"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

DOCS=( README.rst ChangeLog.md )

python_compile() {
	if [[ python_is_python3 || "$EPYTHON}" == 'pypy3' ]]; then
		local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	fi
	distutils-r1_python_compile
}

python_test() {
	esetup.py test
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
