# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A pipeline manipulation library"
HOMEPAGE="https://libpipeline.nongnu.org/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-libs/check )"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf --disable-static
}

src_install() {
	default

	find "${ED}" -type f -name "*.la" -delete || die
}
