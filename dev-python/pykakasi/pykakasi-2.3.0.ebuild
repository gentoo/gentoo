# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Kana kanji simple inversion library"
HOMEPAGE="
	https://pypi.org/project/pykakasi/
	https://codeberg.org/miurahr/pykakasi
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64"

RDEPEND="
	dev-python/deprecated[${PYTHON_USEDEP}]
	dev-python/jaconv[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=(
	# https://codeberg.org/miurahr/pykakasi/pulls/175
	# Avoids several pointless, unpackaged test deps
	"${FILESDIR}"/0001-tests-make-benchmarking-optional.patch
	# released with a failing test and immediately fixed after...
	"${FILESDIR}"/0001-fix-update-test-expectation.patch
)

python_test() {
	epytest -m 'not benchmark'
}
