# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 python3_8 python3_9 )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1

DESCRIPTION="provides a Resolver class that includes dependency resolution logic"
HOMEPAGE="https://github.com/sarugaku/resolvelib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~x64-macos"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
