# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Small but powerful library implementing the client-server IRC protocol"
HOMEPAGE="https://www.ulduzsoft.com/libircclient/"
SRC_URI="https://downloads.sourceforge.net/libircclient/${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc ssl static-libs threads"

DEPEND="ssl? (
		dev-libs/openssl:0=
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
		$(use_enable ssl openssl)
		$(use_enable ssl threads)
		--enable-ipv6
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
