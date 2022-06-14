# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Parser interpreter based on PEG grammars"
HOMEPAGE="https://pypi.org/project/Arpeggio/ https://github.com/textX/Arpeggio"
SRC_URI="
	https://github.com/textX/Arpeggio/archive/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"

DEPEND="
	test? (
		dev-python/memory_profiler[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e '/^setup_requires/,/^[^[:space:]]/d' setup.cfg || die
	distutils-r1_python_prepare_all
}
