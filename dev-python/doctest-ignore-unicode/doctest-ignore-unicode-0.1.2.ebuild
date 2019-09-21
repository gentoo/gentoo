# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Add flag to ignore unicode literal prefixes in doctests"
HOMEPAGE="https://pypi.org/project/doctest-ignore-unicode/ https://github.com/gnublade/doctest-ignore-unicode"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 ~arm64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/nose[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
