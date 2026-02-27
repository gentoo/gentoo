# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Indexes and searches Maildir/MH folders"
HOMEPAGE="https://github.com/vandry/mairix"
SRC_URI="https://github.com/vandry/mairix/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE="zlib bzip2"

RDEPEND="
	dev-libs/openssl:=
	zlib? ( virtual/zlib:= )
	bzip2? ( app-arch/bzip2 )
"

DEPEND="${RDEPEND}
	app-alternatives/lex
	app-alternatives/yacc
"

# Fail on various locales
RESTRICT="test"

src_prepare() {
	default

	# econf would fail with unknown options.
	# Now it only prints "Unrecognized option".
	sed -i -e "/^[[:space:]]*bad_options=yes/d" "${S}"/configure || die "sed failed"
}

src_configure() {
	tc-export CC
	econf \
		$(use_enable zlib gzip-mbox) \
		$(use_enable bzip2 bzip-mbox)
}

src_compile() {
	emake -j1 # 923146
}

src_install() {
	dobin mairix
	doman mairix.1 mairixrc.5
	dodoc NEWS README dotmairixrc.eg
}
