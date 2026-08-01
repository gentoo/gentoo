# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry-core
PYPI_VERIFY_REPO=https://github.com/python-syndication/feedparser-sgmllib
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="sgmllib from Python 2.7 for feedparser use"
HOMEPAGE="
	https://github.com/python-syndication/feedparser-sgmllib/
	https://pypi.org/project/feedparser-sgmllib/
"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
