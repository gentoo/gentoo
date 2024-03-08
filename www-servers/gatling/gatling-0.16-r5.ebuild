# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="High performance web server"
HOMEPAGE="https://www.fefe.de/gatling/"
SRC_URI="https://www.fefe.de/gatling/${P}.tar.xz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="ssl diet"
REQUIRED_USE="ssl? ( !diet )"

DEPEND=">=dev-libs/libowfat-0.32-r2[diet=]
	sys-libs/zlib
	virtual/libcrypt:=
	diet? ( dev-libs/dietlibc )
	ssl? (
		dev-libs/openssl:0=
	)"
RDEPEND="${DEPEND}
	acct-group/gatling
	acct-user/gatling
	"

PATCHES=(
	"${FILESDIR}/${PN}-0.13-compile.patch"
	"${FILESDIR}/${PN}-0.15-ar.patch"
	"${FILESDIR}/${PN}-0.16-r4-0001-try-alloca-socket-fix-Wimplicit-int.patch"
)

src_prepare() {
	default
	rm Makefile  # leaves us with GNUmakefile
}

src_compile() {
	local DIET=
	use diet && DIET='/usr/bin/diet'

	local targets='gatling'
	use ssl && targets+=' tlsgatling'

	emake DIET="${DIET}" CC="$(tc-getCC)" \
			CFLAGS="${CFLAGS} -I${ESYSROOT}/usr/include/libowfat" \
			LDFLAGS="${LDFLAGS}" prefix=/usr ${targets}
}

src_install() {
	doman gatling.1

	newconfd "${FILESDIR}/gatling.confd" gatling
	newinitd "${FILESDIR}/gatling.initd-3" gatling
	dodoc README.{ftp,http}

	dobin gatling
	use ssl && {
		dodoc README.tls
		dobin tlsgatling
	}
}
