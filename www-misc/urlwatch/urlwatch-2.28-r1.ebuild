# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

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
		app-text/tesseract[png]
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/jq[${PYTHON_USEDEP}]
		dev-python/pytesseract[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-lxml-5.patch"
)

DOCS=( CHANGELOG.md README.md )

distutils_enable_sphinx docs/source dev-python/alabaster
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Require the pdftotext module
	"lib/urlwatch/tests/test_filter_documentation.py::test_url[https://example.net/pdf-test.pdf]"
	"lib/urlwatch/tests/test_filter_documentation.py::test_url[https://example.net/pdf-test-password.pdf]"
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
		if ! has_version dev-python/pytesseract; then
			elog "Install 'dev-python/pytesseract' to enable OCR support"
		fi
		elog "HTML parsing can be improved by installing one of the following packages"
		elog "and changing the html2text subfilter parameter:"
		elog "dev-python/beautifulsoup4"
		elog "app-text/html2text"
		elog "dev-python/html2text"
		elog "www-client/lynx"
	fi
}
