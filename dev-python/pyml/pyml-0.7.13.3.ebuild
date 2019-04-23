# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MYP=PyML-${PV}

DESCRIPTION="Python machine learning package"
HOMEPAGE="http://pyml.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MYP}"

python_test() {
	pushd data >/dev/null || die
		"${EPYTHON}" -c "from PyML.demo import pyml_test; pyml_test.test('svm')" || die "tests failed"
	popd >/dev/null || die
}

python_install_all() {
	if use doc; then
		dodoc doc/tutorial.pdf
		HTML_DOCS=( doc/autodoc/. )
	fi

	distutils-r1_python_install_all
}
