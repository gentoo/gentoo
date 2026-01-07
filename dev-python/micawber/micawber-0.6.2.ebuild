# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="A small library for extracting rich content from urls"
HOMEPAGE="
	https://github.com/coleifer/micawber/
	https://pypi.org/project/micawber/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
	)
"

python_test() {
	"${EPYTHON}" runtests.py || die "Tests failed with ${EPYTHON}"
}
