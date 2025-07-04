# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="The logutils package provides a set of handlers for the Python standard"
HOMEPAGE="
	https://bitbucket.org/vinay.sajip/logutils/
	https://pypi.org/project/logutils/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-db/redis
		dev-python/redis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

PATCHES=(
	# https://bitbucket.org/vinay.sajip/logutils/pull-requests/5
	"${FILESDIR}/${P}-py313.patch"
)

src_prepare() {
	distutils-r1_src_prepare

	sed -i -e 's:assertEquals:assertEqual:' tests/*.py || die
}

python_test() {
	eunittest -s tests
}
