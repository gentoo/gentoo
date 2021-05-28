# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="Filters for web typography, supporting Django & Jinja templates"
HOMEPAGE="https://github.com/mintchaos/typogrify/ https://pypi.org/project/typogrify/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-python/smartypants-1.8.3[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	epytest --doctest-modules typogrify/filters.py typogrify/packages/titlecase/tests.py
}
