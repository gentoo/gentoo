# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="an implementation of an E-component of Network Intrusion Detection System"
HOMEPAGE="http://libnids.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1.2"
KEYWORDS="amd64 ppc x86"
IUSE="+glib +libnet static-libs"

RDEPEND="
	!net-libs/libnids:1.1
	net-libs/libpcap
	glib? ( dev-libs/glib:2 )
	libnet? ( >=net-libs/libnet-1.1.0-r3 )
"
DEPEND="
	${RDEPEND}
	glib? ( virtual/pkgconfig )
"
PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-libdir.patch
	"${FILESDIR}"/${P}-static-libs.patch
)

src_prepare() {
	default
	eautoconf
}

src_configure() {
	tc-export AR
	append-flags -fno-strict-aliasing

	econf \
		--enable-shared \
		$(usex glib '' --disable-libglib) \
		$(use_enable libnet)
}

src_compile() {
	emake shared $(usex static-libs static '')
}

src_install() {
	local tgt
	for tgt in _installshared $(usex static-libs _install ''); do
		emake install_prefix="${D}" ${tgt}
	done

	dodoc CHANGES CREDITS MISC README doc/*
}
