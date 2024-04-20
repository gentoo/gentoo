# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="RFC1459 and IRCv3 protocol tokeniser library"
HOMEPAGE="
	https://github.com/jesopo/irctokens
	https://pypi.org/project/irctokens/
"
# sdist is broken (missing VERSION)
SRC_URI="
	https://github.com/jesopo/irctokens/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.2-exclude-tests.patch
)

BDEPEND="
	test? (
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
