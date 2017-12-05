# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils toolchain-funcs user

DESCRIPTION="High performance web server"
HOMEPAGE="https://www.fefe.de/gatling/"
SRC_URI="https://www.fefe.de/gatling/${P}.tar.xz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="libressl ssl diet"
REQUIRED_USE="ssl? ( !diet )"

DEPEND=">=dev-libs/libowfat-0.25[diet=]
	diet? ( dev-libs/dietlibc )
	ssl? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)"
RDEPEND="${DEPEND}"

src_prepare() {
	rm Makefile  # leaves us with GNUmakefile
	epatch "${FILESDIR}/${PN}-0.13-compile.patch"
	eapply_user
}

src_compile() {
	local DIET=
	use diet && DIET='/usr/bin/diet'

	local targets='gatling'
	use ssl && targets+=' tlsgatling'

	emake DIET="${DIET}" CC="$(tc-getCC)" \
			CFLAGS="${CFLAGS} -I${ROOT}usr/include/libowfat" \
			LDFLAGS="${LDFLAGS}" prefix=/usr ${targets} \
			|| die "emake ${targets} failed"
}

src_install() {
	doman gatling.1 || die "installing manpage failed"

	newconfd "${FILESDIR}/gatling.confd" gatling || die
	newinitd "${FILESDIR}/gatling.initd-3" gatling || die
	dodoc README.{ftp,http} || die "installing docs failed"

	dobin gatling || die "installing gatling binary failed"
	use ssl && {
		dodoc README.tls || die "installing docs failed"
		dobin tlsgatling || die "installing tlsgatling binary failed"
	}
}

pkg_setup() {
	ebegin "Creating gatling user and group"
	enewgroup gatling
	enewuser ${PN} -1 -1 /var/www/localhost ${PN}
}
