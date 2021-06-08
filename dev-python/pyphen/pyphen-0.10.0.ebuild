# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python module for hyphenation using hunspell dictionaries"
HOMEPAGE="https://github.com/Kozea/Pyphen"
SRC_URI="https://github.com/Kozea/Pyphen/archive/${PV}.tar.gz -> ${P^}.tar.gz"
S=${WORKDIR}/${P^}

LICENSE="GPL-2+ LGPL-2+ MPL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"

distutils_enable_tests pytest

python_test() {
	epytest test.py
}
