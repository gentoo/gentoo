# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1 optfeature

DESCRIPTION="Python wrapper of telegram bots API"
HOMEPAGE="https://docs.python-telegram-bot.org https://github.com/python-telegram-bot/python-telegram-bot"
SRC_URI="https://github.com/python-telegram-bot/python-telegram-bot/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/cachetools-5.3.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-39.0.1[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.23.3[${PYTHON_USEDEP}]
	>=dev-python/tornado-6.2[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		>=dev-python/tornado-6.2[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-no-internet-tests.patch"
)

S="${WORKDIR}/${PN}-${PV}"

distutils_enable_tests pytest

# Run only the tests that don't require a connection
python_test() {
	epytest -m no_req
}

python_prepare_all() {
	distutils-r1_python_prepare_all
}

pkg_postinst() {
	optfeature_header "Optional package dependencies:"
	optfeature "using telegram.ext.JobQueue" dev-python/APScheduler
}
