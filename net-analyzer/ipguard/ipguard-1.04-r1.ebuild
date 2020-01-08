# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Tool designed to protect LAN IP adress space by ARP spoofing"
HOMEPAGE="http://ipguard.deep.perm.ru/"
SRC_URI="${HOMEPAGE}files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	net-libs/libnet:1.1
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	default

	sed -i \
		-e 's|-g ||g' \
		-e 's|	@$(CC)|	$(CC)|g' \
		-e 's| -s | |g' \
		-e 's| -o | $(CFLAGS) $(LDFLAGS)&|g' \
		-e 's|$(PREFIX)|${D}&|g' \
		-e 's|/man/|/share&|g' \
		Makefile || die
	sed -i \
		-e 's|opts=|extra_commands=|g' \
		-e 's|/var/run/|/run/|g' \
		-e 's|-u 300 -xz|${OPTS} ${IFACE}|g' \
		doc/${PN}.gentoo || die
	sed -i \
		-e 's|/var/run/|/run/|g' \
		doc/${PN}.8 ${PN}.h || die
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		LIBNET_CONFIG="$(tc-getPKG_CONFIG) libnet" \
		PREFIX=\"${EPREFIX:-/usr}\"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		LIBNET_CONFIG="$(tc-getPKG_CONFIG) libnet" \
		PREFIX=\"${EPREFIX:-/usr}\" \
		install

	newinitd doc/${PN}.gentoo ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	dodoc doc/{NEWS,README*,ethers.sample}
}
