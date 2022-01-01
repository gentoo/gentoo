# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Python extension that wraps hiredis"
HOMEPAGE="https://github.com/redis/hiredis-py/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~sparc x86"
IUSE="system-libs"

DEPEND="system-libs? ( >=dev-libs/hiredis-1.0.0:= )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-CVE-2021-32765.patch
)

src_prepare() {
	use system-libs && PATCHES+=(
		"${FILESDIR}"/${P}-system-libs.patch
	)
	sed -i -e 's:description-file:description_file:' setup.cfg || die
	default
}

python_test() {
	cd test || die
	"${EPYTHON}" -m unittest -v reader.ReaderTest || die "tests failed"
}
