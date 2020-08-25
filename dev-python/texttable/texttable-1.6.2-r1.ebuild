# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1 eutils

DESCRIPTION="Module for creating simple ASCII tables"
HOMEPAGE="https://github.com/foutaise/texttable https://pypi.org/project/texttable/"
SRC_URI="https://github.com/foutaise/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/wcwidth[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_test() {
	pytest -vv tests.py || die
}

pkg_postinst() {
	elog "Optional features: "
	optfeature "better wrapping of CJK text" dev-python/cjkwrap
}
