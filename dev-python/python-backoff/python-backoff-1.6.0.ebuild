# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MY_PN=${PN#python-}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Function decoration for backoff and retry"
HOMEPAGE="https://github.com/litl/backoff https://pypi.org/project/backoff/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
RESTRICT="test"
S=${WORKDIR}/${MY_P}

DOCS=( README.rst )

python_test() {
	emake test
}
