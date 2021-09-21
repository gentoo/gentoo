# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Parser interpreter based on PEG grammars"
HOMEPAGE="https://pypi.org/project/Arpeggio/ https://github.com/textX/Arpeggio"
SRC_URI="https://github.com/textX/Arpeggio/archive/${PV}.tar.gz -> ${P^}.tar.gz"
S=${WORKDIR}/${P^}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

DEPEND="
	test? (
		dev-python/memory_profiler[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -e '/^setup_requires/,/^[^[:space:]]/d' \
		-e '/^exclude/a\
    examples.*' \
		-i setup.cfg || die
	distutils-r1_python_prepare_all
}
