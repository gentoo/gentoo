# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd toolchain-funcs user

DESCRIPTION="P2P mesh VPN"
HOMEPAGE="https://github.com/peervpn/peervpn"
EGIT_COMMIT="eb35174277fbf745c5ee0d5875d659dad819adfc"
SRC_URI="https://github.com/peervpn/peervpn/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="dev-libs/openssl:0="
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-${EGIT_COMMIT}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -e 's|^CFLAGS+=-O2||' -i Makefile || die
}

src_compile() {
	emake CC=$(tc-getCC) || die
}

src_install() {
	dosbin ${PN}

	insinto /etc/${PN}
	newins peervpn.conf peervpn.conf.example
	fowners ${PN}:${PN} /etc/${PN}
	fperms 0700 /etc/${PN}

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /var/log/${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}
