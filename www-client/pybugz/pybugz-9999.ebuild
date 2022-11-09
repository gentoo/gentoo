# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="readline(+),ssl(+)"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/williamh/pybugz.git"
	inherit git-r3
else
	SRC_URI="https://github.com/williamh/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"
fi

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Command line interface to (Gentoo) Bugzilla"
HOMEPAGE="https://github.com/williamh/pybugz"

LICENSE="GPL-2"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_install_all() {
	distutils-r1_python_install_all
	newbashcomp contrib/bash-completion bugz

	insinto /usr/share/zsh/site-functions
	newins contrib/zsh-completion _pybugz
}
