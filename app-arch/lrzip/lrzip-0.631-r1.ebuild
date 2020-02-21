# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Long Range ZIP or Lzma RZIP optimized for compressing large files"
HOMEPAGE="https://github.com/ckolivas/lrzip"
SRC_URI="http://ck.kolivas.org/apps/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND="dev-libs/lzo
	 app-arch/bzip2
	 sys-libs/zlib"
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )
	virtual/perl-Pod-Parser"

PATCHES=(
	"${FILESDIR}"/${PN}-missing-stdarg_h.patch
	"${FILESDIR}"/${P}-solaris.patch
)

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	# Don't collide with net-dialup/lrzsz and /usr/bin/lrz, bug #588206
	rm -f "${ED}"/usr/bin/lrz
	rm -f "${ED}"/usr/share/man/man1/lrz.*

	find "${D}" -name '*.la' -delete || die
}
