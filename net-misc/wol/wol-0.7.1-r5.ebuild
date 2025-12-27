# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Implements Wake On LAN (Magic Paket) functionality in a small program"
HOMEPAGE="http://ahh.sourceforge.net/wol/"
SRC_URI="https://downloads.sourceforge.net/ahh/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="nls"

PATCHES=(
	"${FILESDIR}/${P}-musl.patch"
	"${FILESDIR}/${P}-Fix-config.h-test-consumption.patch"
	"${FILESDIR}/${P}-Fix-malloc-detection.patch"
	"${FILESDIR}/${P}-linux-headers.patch"
	"${FILESDIR}/${P}-intl.patch"
)

src_prepare() {
	default

	# https://bugs.gentoo.org/945522
	rm -r intl/ lib/getopt.h || die

	# bug #874420
	eautoreconf
}

src_configure() {
	export jm_cv_func_working_{re,m}alloc=yes

	local myeconfargs=(
		--disable-rpath
		$(use_enable nls)
	)

	econf ${myeconfargs[@]}
}

src_compile() {
	emake AR="$(tc-getAR)"
}
