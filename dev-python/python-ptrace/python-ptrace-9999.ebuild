# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A Python binding of ptrace library"
HOMEPAGE="
	https://github.com/vstinner/python-ptrace/
	https://pypi.org/project/python-ptrace/
"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vstinner/python-ptrace"
else
	SRC_URI="
		https://github.com/vstinner/python-ptrace/archive/${PV}.tar.gz
			-> ${P}.gh.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

distutils_enable_tests pytest

python_test() {
	"${EPYTHON}" runtests.py -v --tests tests/ || die
}
