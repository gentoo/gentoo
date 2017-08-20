# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Statistical analysis tool for git repositories"
HOMEPAGE="https://github.com/ejwa/gitinspector"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="dev-vcs/git"
DEPEND="test? ( ${RDEPEND} )"

python_prepare_all() {
	[[ ${LC_ALL} == "C" ]] && export LC_ALL="en_US.utf8"

	# Otherwise this gets installed with the *.txt glob.
	rm LICENSE.txt || die 'failed to remove LICENSE.txt'

	# Use /usr/share/doc/${PF} instead of /usr/share/doc/${PN}.
	sed -i setup.py \
		-e "s:share/doc/gitinspector:share/doc/${PF}:" \
		|| die 'failed to fix the documentation path in setup.py'

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	# The distutils install routine misses some important documentation.
	doman docs/gitinspector.1
	dodoc docs/*.{pdf,css,html,txt}
}
