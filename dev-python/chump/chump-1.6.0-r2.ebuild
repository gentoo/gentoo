# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="API wrapper for Pushover"
HOMEPAGE="https://github.com/karanlyons/chump"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# 'html_theme' is unset, meaning alabaster will be used
# and sphinx depends on it
distutils_enable_sphinx docs

# The package has no test suite
