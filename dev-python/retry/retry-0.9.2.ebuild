# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Easy to use retry decorator"
HOMEPAGE="
	https://pypi.org/project/retry
	https://github.com/invl/retry
"

SRC_URI="
	https://github.com/invl/retry/archive/refs/tags/${PV}.tar.gz 
	-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

python_test() {
	unset PYTHONPATH
	export TMPDIR="${T}"
}

python_install_all() {
	distutils-r1_python_install_all
}
