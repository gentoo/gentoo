# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} pypy3 )

inherit distutils-r1

MY_PN="geoip-api-python"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python bindings for GeoIP"
HOMEPAGE="https://github.com/maxmind/geoip-api-python"
SRC_URI="https://github.com/maxmind/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ~ppc ~sparc x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-libs/geoip-1.4.8"
DEPEND="${RDEPEND}"

DOCS=( README.rst ChangeLog.md )

distutils_enable_tests nose

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
