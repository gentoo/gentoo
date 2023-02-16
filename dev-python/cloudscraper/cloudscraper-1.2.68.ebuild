# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 optfeature

DESCRIPTION="A Python module to bypass Cloudflare's anti-bot page"
HOMEPAGE="
	https://github.com/VeNoMouS/cloudscraper/
	https://pypi.org/project/cloudscraper/
"
SRC_URI="
	https://github.com/VeNoMouS/cloudscraper/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/requests-toolbelt[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/js2py[${PYTHON_USEDEP}]
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		net-libs/nodejs
	)
"

# These tests fail for no understanadble reason
EPYTEST_DESELECT=(
	"tests/test_cloudscraper.py::TestCloudScraper::test_bad_interpreter_js_challenge1_16_05_2020"
	"tests/test_cloudscraper.py::TestCloudScraper::test_bad_solve_js_challenge1_16_05_2020"
	"tests/test_cloudscraper.py::TestCloudScraper::test_Captcha_challenge_12_12_2019"
	"tests/test_cloudscraper.py::TestCloudScraper::test_reCaptcha_providers"
)

distutils_enable_tests pytest

pkg_postinst() {
	optfeature "brotli decompresssion support" "dev-python/brotlipy"

	optfeature "js2py interpreter support" "dev-python/js2py"
	optfeature "node.js interpreter support" "net-libs/nodejs"
}
