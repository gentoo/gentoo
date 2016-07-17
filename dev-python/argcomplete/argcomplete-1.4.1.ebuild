# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 bash-completion-r1

DESCRIPTION="Bash tab completion for argparse"
HOMEPAGE="https://pypi.python.org/pypi/argcomplete"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	# purge test folder to avoid file collisions
	sed -e "s:find_packages():find_packages(exclude=['test','test.*']):" -i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	${EPYTHON} test/test.py || die
}

python_install_all() {
	sed \
		-e "/complete /d" \
		-i argcomplete/bash_completion.d/python-argcomplete.sh || die

	distutils-r1_python_install_all
	newbashcomp "${S}"/${PN}/bash_completion.d/python-argcomplete.sh python-${PN}
}
