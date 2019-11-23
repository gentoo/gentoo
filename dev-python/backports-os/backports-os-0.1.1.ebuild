# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Backport of new features in Python's os module"
HOMEPAGE="https://github.com/pjdelport/backports.os"
SRC_URI="https://github.com/pjdelport/backports.os/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/backports[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${P/-/.}"

src_prepare() {
	export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"
	distutils-r1_src_prepare
}

python_test() {
	esetup.py test
}

python_install() {
	distutils-r1_python_install
	# main namespace provided by dev-python/backports
	rm "${D}/$(python_get_sitedir)"/backports/__init__.py* || die
	rm -rf "${D}/$(python_get_sitedir)"/backports/__pycache__ || die
}
