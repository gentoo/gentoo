# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python implementation of the Varlink protocol"
HOMEPAGE="https://github.com/varlink/python"
SRC_URI="
	https://github.com/varlink/python/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/python-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/future[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${P}-fix.py3.10.patch"
)

distutils_enable_tests unittest

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed -e '/setuptools_scm/d' -i setup.cfg || die
	sed -e "s/use_scm_version=True/version='${PV}'/" -i setup.py || die
}
