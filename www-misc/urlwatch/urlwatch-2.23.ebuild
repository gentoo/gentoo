# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A tool for monitoring webpages for updates"
HOMEPAGE="https://thp.io/2008/urlwatch/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/cssselect[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/minidb[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/docutils[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGELOG.md README.md )

distutils_enable_sphinx docs/source dev-python/alabaster
distutils_enable_tests pytest

python_test() {
	local skipped_tests=(
		# Require the pdftotext module
		"lib/urlwatch/tests/test_filter_documentation.py::test_url[https://example.net/pdf-test.pdf-job12]"
		"lib/urlwatch/tests/test_filter_documentation.py::test_url[https://example.net/pdf-test-password.pdf-job13]"
		# Require the pytesseract module
		"lib/urlwatch/tests/test_filter_documentation.py::test_url[https://example.net/ocr-test.png-job26]"
		"lib/urlwatch/tests/test_filter_documentation.py::test_url[https://example.net/ocr-test.png-job27]"
		# Requires the jq module
		"lib/urlwatch/tests/test_filter_documentation.py::test_url[https://example.net/jobs.json-job28]"
		# Skip code quality check
		"lib/urlwatch/tests/test_handler.py::test_pep8_conformance"
	)
	epytest ${skipped_tests[@]/#/--deselect }
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		if ! has_version dev-python/chump; then
			elog "Install 'dev-python/chump' to enable Pushover" \
				"notifications support"
		fi
		if ! has_version dev-python/pushbullet-py; then
			elog "Install 'dev-python/pushbullet-py' to enable" \
				"Pushbullet notifications support"
		fi
		elog "HTML parsing can be improved by installing one of the following packages"
		elog "and changing the html2text subfilter parameter:"
		elog "dev-python/beautifulsoup:4"
		elog "app-text/html2text"
		elog "dev-python/html2text"
		elog "www-client/lynx"
	fi
}
