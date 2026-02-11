# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYPI_VERIFY_REPO=https://github.com/urschrei/pyzotero
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A Python client for the Zotero API"
HOMEPAGE="
	https://github.com/urschrei/pyzotero/
	https://pypi.org/project/pyzotero/
"

LICENSE="BlueOak-1.0.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-text/zotero-bin
	<dev-python/bibtexparser-2[${PYTHON_USEDEP}]
	>=dev-python/bibtexparser-1.4.3[${PYTHON_USEDEP}]
	>=dev-python/feedparser-6.0.12[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
	>=dev-python/whenever-0.8.8[${PYTHON_USEDEP}]
"

BDEPEND="
	>=dev-python/trove-classifiers-2024.7.2[${PYTHON_USEDEP}]
	test? (
		dev-python/ipython[${PYTHON_USEDEP}]
		>=dev-python/pytz-2025.2[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		>=dev-python/tzdata-2025.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx doc \
	dev-python/sphinx-rtd-theme
EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

python_test() {
	> tests/__init__.py || die
	epytest -o addopts=
}
