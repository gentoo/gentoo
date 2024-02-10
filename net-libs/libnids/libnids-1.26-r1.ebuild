# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="An implementation of an E-component of Network Intrusion Detection System"
HOMEPAGE="https://github.com/MITRECND/libnids http://libnids.sourceforge.net/"
SRC_URI="https://github.com/MITRECND/libnids/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1.2"
KEYWORDS="amd64 ppc x86"
IUSE="+glib +libnet static-libs"

RDEPEND="!net-libs/libnids:1.1
	net-libs/libpcap
	glib? ( dev-libs/glib:2 )
	libnet? ( >=net-libs/libnet-1.1.0-r3 )"
DEPEND="${RDEPEND}"
BDEPEND="glib? ( virtual/pkgconfig )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.24-ldflags.patch
	"${FILESDIR}"/${PN}-1.24-libdir.patch
	"${FILESDIR}"/${PN}-1.24-static-libs.patch
	"${FILESDIR}"/${PN}-1.24-no-inline.patch
	"${FILESDIR}"/${PN}-1.26-revert-SONAME-bump.patch
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
