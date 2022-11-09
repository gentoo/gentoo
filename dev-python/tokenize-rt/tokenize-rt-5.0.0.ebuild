# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="A wrapper around the stdlib 'tokenize' which roundtrips"
HOMEPAGE="https://github.com/asottile/tokenize-rt"
SRC_URI="
	https://github.com/asottile/tokenize-rt/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
