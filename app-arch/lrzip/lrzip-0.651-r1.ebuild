# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Long Range ZIP or Lzma RZIP optimized for compressing large files"
HOMEPAGE="https://github.com/ckolivas/lrzip"
SRC_URI="https://github.com/ckolivas/lrzip/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="static-libs"

RDEPEND="app-arch/bzip2
	app-arch/lz4
	dev-libs/lzo
	sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="dev-perl/Pod-Parser
	amd64? ( dev-lang/nasm )
	x86? ( dev-lang/nasm )"

PATCHES=(
	# Bug #923990, not required in >0.651
	"${FILESDIR}/fix-incorrect-use-of-shell-commands-in-handmade.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# ASM optimizations are only available on amd64 and x86, bug #829003
	local asm=no
	if use amd64 || use x86; then
		asm=yes
	fi

	econf \
		$(use_enable static-libs static) \
		--enable-asm=${asm}
}

src_install() {
	default
	# Don't collide with net-dialup/lrzsz and /usr/bin/lrz, bug #588206
	rm -f "${ED}"/usr/bin/lrz || die
	rm -f "${ED}"/usr/share/man/man1/lrz.* || die

	find "${ED}" -name '*.la' -delete || die
}
