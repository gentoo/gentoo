# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

DESCRIPTION="Python library to parse Linux /proc/mdstat"
HOMEPAGE="
	https://github.com/nicolargo/pymdstat/
	https://pypi.org/project/pymdstat/
"
SRC_URI="
	https://github.com/nicolargo/pymdstat/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

python_prepare_all() {
	# docs
	sed -e '/data_files/ d' -i setup.py || die "sed failed"
	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" unitest.py -v || die "testing failed with ${EPYTHON}"
}
