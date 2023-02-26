# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A tool for monitoring webpages for updates"
HOMEPAGE="
	https://thp.io/2008/urlwatch/
	https://github.com/thp/urlwatch/
	https://pypi.org/project/urlwatch/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/cssselect[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	>=dev-python/minidb-2.0.6[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/jq[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGELOG.md README.md )

distutils_enable_sphinx docs/source dev-python/alabaster
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Require the pdftotext module
	"lib/urlwatch/tests/test_filter_documentation.py::test_url[https://example.net/pdf-test.pdf]"
	"lib/urlwatch/tests/test_filter_documentation.py::test_url[https://example.net/pdf-test-password.pdf]"
	# Requires the pytesseract module
	"lib/urlwatch/tests/test_filter_documentation.py::test_url[https://example.net/ocr-test.png]"
	# Fail because of argv parsing: https://github.com/thp/urlwatch/issues/677
	"lib/urlwatch/tests/test_handler.py::test_run_watcher"
	"lib/urlwatch/tests/test_handler.py::test_number_of_tries_in_cache_is_increased"
	"lib/urlwatch/tests/test_handler.py::test_report_error_when_out_of_tries"
	"lib/urlwatch/tests/test_handler.py::test_reset_tries_to_zero_when_successful"
	# Skip code quality check
	"lib/urlwatch/tests/test_handler.py::test_pep8_conformance"
)

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		if ! has_version dev-python/chump; then
			elog "Install 'dev-python/chump' to enable Pushover" \
				"notifications support"
		fi
		if ! has_version dev-python/jq; then
			elog "Install 'dev-python/jq' to enable jq filtering support"
		fi
		if ! has_version dev-python/pushbullet-py; then
			elog "Install 'dev-python/pushbullet-py' to enable" \
				"Pushbullet notifications support"
		fi
		elog "HTML parsing can be improved by installing one of the following packages"
		elog "and changing the html2text subfilter parameter:"
		elog "dev-python/beautifulsoup4"
		elog "app-text/html2text"
		elog "dev-python/html2text"
		elog "www-client/lynx"
	fi
}
