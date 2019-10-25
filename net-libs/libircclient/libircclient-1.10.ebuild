# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Small but powerful library implementing the client-server IRC protocol"
HOMEPAGE="http://www.ulduzsoft.com/libircclient/"
SRC_URI="mirror://sourceforge/libircclient/${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="doc ipv6 libressl ssl static-libs threads"

DEPEND="ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8-build.patch
	"${FILESDIR}"/${PN}-1.10-shared.patch
	"${FILESDIR}"/${PN}-1.8-static.patch
	"${FILESDIR}"/${PN}-1.8-include.patch

	# upstream patches (can usually be removed with next version bump)
	"${FILESDIR}"/${PN}-1.10-openssl.patch
)

src_prepare() {
	default
	mv configure.in configure.ac || die
	eautoconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable threads)
		$(use_enable ipv6)
		$(use_enable ssl openssl)
		$(use_enable ssl threads)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake -C src $(usex static-libs "shared static" "shared")
}

src_install() {
	emake -C src DESTDIR="${D}" install-shared $(usex static-libs "install-static" "")
	insinto /usr/include/libircclient
	doins include/*.h

	dodoc Changelog THANKS
	doman man/libircclient.1
}
