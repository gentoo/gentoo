# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Redirects TCP connections from one IP address and port to another"
HOMEPAGE="http://www.boutell.com/rinetd/"
SRC_URI="http://www.boutell.com/rinetd/http/rinetd.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.62-implicit-decl.patch
)

src_prepare() {
	default

	sed -i -e "s:gcc:$(tc-getCC) \$(CFLAGS) \$(CPPFLAGS) \$(LDFLAGS):" Makefile || die
}

src_compile() {
	use kernel_linux && append-cppflags -DLINUX

	tc-export CC

	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dosbin rinetd
	newinitd "${FILESDIR}"/rinetd.rc rinetd
	doman rinetd.8
	dodoc CHANGES README index.html
}
