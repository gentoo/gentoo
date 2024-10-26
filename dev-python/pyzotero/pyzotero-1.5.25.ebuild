# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

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
	dev-python/bibtexparser[${PYTHON_USEDEP}]
	>=dev-python/feedparser-6.0.11[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/requests-2.21.0[${PYTHON_USEDEP}]
"

BDEPEND="
	>=dev-python/trove-classifiers-2024.7.2[${PYTHON_USEDEP}]
	test? (
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/httpretty[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx doc --no-autodoc
distutils_enable_tests pytest
