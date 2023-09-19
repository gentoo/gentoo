# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Utility to report and remove the executable flag from an ELF object's GNU_STACK"
HOMEPAGE="https://dev.gentoo.org/~blueness/fix-gnustack"
SRC_URI="https://dev.gentoo.org/~blueness/${PN}/${P}.tar.bz2"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="dev-libs/elfutils"
RDEPEND="${DEPEND}"

PATCHES=(
	# Backports from master, drop on next release
	"${FILESDIR}"/${PV}
)

src_prepare() {
	default

	# Drop on next release, only needed for tests patch
	eautoreconf
}
