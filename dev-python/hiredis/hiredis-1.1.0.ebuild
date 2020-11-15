# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit distutils-r1

DESCRIPTION="Python extension that wraps hiredis"
HOMEPAGE="https://github.com/pietern/hiredis-py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="system-libs"

DEPEND="system-libs? ( dev-libs/hiredis:0/0.14 )"
RDEPEND="${DEPEND}"

src_prepare() {
	use system-libs && PATCHES+=(
		"${FILESDIR}"/${PN}-1.0.1-system-libs.patch
		"${FILESDIR}"/${PN}-1.0.1-api-0.14.patch
	)
	default
}

python_test() {
	cd test
	"${EPYTHON}" -m unittest reader.ReaderTest || die "tests failed"
}
