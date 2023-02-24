# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} pypy3 )
inherit distutils-r1

DESCRIPTION="Python extension that wraps hiredis"
HOMEPAGE="https://github.com/redis/hiredis-py/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="system-libs"

DEPEND="system-libs? ( >=dev-libs/hiredis-1.0.0:= )"
RDEPEND="${DEPEND}"

src_prepare() {
	use system-libs && PATCHES+=(
		"${FILESDIR}"/${P}-system-libs.patch
	)
	default
}
