# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Python extension that wraps hiredis"
HOMEPAGE="https://github.com/redis/hiredis-py/"
SRC_URI="https://github.com/redis/hiredis-py/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

DEPEND=">=dev-libs/hiredis-1.0.0:="
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}-py-${PV}

PATCHES=(
	"${FILESDIR}"/${P}-system-libs.patch
)

distutils_enable_tests pytest

python_test() {
	cd tests
	epytest --import-mode=append
}
