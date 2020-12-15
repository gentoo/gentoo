# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )
inherit distutils-r1

DESCRIPTION="The client library for BackBlaze's B2 product"
HOMEPAGE="https://github.com/Backblaze/b2-sdk-python"
SRC_URI="https://github.com/Backblaze/b2-sdk-python/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/${PN}-1.2.0-skip-integration-test.patch"
)

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/arrow-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/logfury-0.1.2[${PYTHON_USEDEP}]
		>=dev-python/requests-2.9.1[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.5.0[${PYTHON_USEDEP}]
	')
"

distutils_enable_tests pytest

BDEPEND+=" test? (
	$(python_gen_cond_dep '
		>=dev-python/pytest-mock-3.3.1[${PYTHON_USEDEP}]
	')
)"
