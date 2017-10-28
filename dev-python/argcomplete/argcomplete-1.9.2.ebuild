# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy pypy3 )

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Bash tab completion for argparse"
HOMEPAGE="https://pypi.python.org/pypi/argcomplete"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86 ~arm ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pexpect[${PYTHON_USEDEP}]
		app-shells/tcsh )"

python_test() {
	"${EPYTHON}" test/test.py || die
}

python_install_all() {
	distutils-r1_python_install_all
	newbashcomp "${S}"/${PN}/bash_completion.d/python-argcomplete.sh python-${PN}
}
