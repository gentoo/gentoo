# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Tools for testing processes"
HOMEPAGE="https://github.com/ionelmc/python-process-tests https://pypi.python.org/pypi/process-tests"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
