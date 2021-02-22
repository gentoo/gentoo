# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Long Range ZIP or Lzma RZIP optimized for compressing large files"
HOMEPAGE="https://github.com/ckolivas/lrzip"
SRC_URI="https://github.com/ckolivas/lrzip/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND="
	app-arch/bzip2
	dev-libs/lzo
	app-arch/lz4
	sys-libs/zlib
"
DEPEND="
	${RDEPEND}
	virtual/perl-Pod-Parser
	x86? ( dev-lang/nasm )
"

PATCHES=(
	"${FILESDIR}"/${PN}-missing-stdarg_h.patch
	"${FILESDIR}"/${PN}-0.631-solaris.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	# Don't collide with net-dialup/lrzsz and /usr/bin/lrz, bug #588206
	rm -f "${ED}"/usr/bin/lrz || die
	rm -f "${ED}"/usr/share/man/man1/lrz.* || die

	find "${D}" -name '*.la' -delete || die
}
