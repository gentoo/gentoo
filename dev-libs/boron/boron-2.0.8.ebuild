# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="A scripting language similar to REBOL"
HOMEPAGE="https://urlan.sourceforge.net/boron/"
SRC_URI="https://downloads.sourceforge.net/urlan/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 readline"

DEPEND="
	bzip2? ( app-arch/bzip2:= )
	!bzip2? ( sys-libs/zlib:= )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.8_makefile.patch"
)

src_configure() {
	tc-export CC
	# Non-standard configure
	edo ./configure \
		$(usex bzip2 "--bzip2" "")
}

src_install() {
	emake DESTDIR="${D}/usr" install install-dev
	dodoc README.md
}
