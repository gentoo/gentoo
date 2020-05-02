# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python extension that wraps hiredis"
HOMEPAGE="https://github.com/pietern/hiredis-py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND=">=dev-libs/hiredis-0.14:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-system-libs.patch
	"${FILESDIR}"/${P}-api-0.14.patch
)

python_test() {
	cd test
	"${EPYTHON}" -m unittest reader.ReaderTest || die "tests failed"
}
