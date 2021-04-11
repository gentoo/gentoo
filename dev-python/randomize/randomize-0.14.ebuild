# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Randomize the order of the tests within a unittest.TestCase class"
HOMEPAGE="https://github.com/nloadholtes/nose-randomize"
SRC_URI="https://github.com/nloadholtes/nose-randomize/archive/master.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/nose-${PN}-master"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
