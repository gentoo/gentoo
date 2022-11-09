# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1 optfeature

DESCRIPTION="A minimal low-level HTTP client"
HOMEPAGE="
	https://www.encode.io/httpcore/
	https://github.com/encode/httpcore/
	https://pypi.org/project/httpcore/
"
SRC_URI="
	https://github.com/encode/httpcore/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://github.com/encode/httpcore/commit/4cf288e0007cb73561b9020af9228f076ba2a94e.patch
		-> ${P}-h11-0.14.patch
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	=dev-python/anyio-3*[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	<dev-python/h11-0.15[${PYTHON_USEDEP}]
	<dev-python/h2-5[${PYTHON_USEDEP}]
	=dev-python/sniffio-1*[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
		dev-python/pytest-trio[${PYTHON_USEDEP}]
		dev-python/socksio[${PYTHON_USEDEP}]
		dev-python/trio[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${DISTDIR}"/${P}-h11-0.14.patch
)

pkg_postinst() {
	optfeature "SOCKS support" dev-python/socksio
}
