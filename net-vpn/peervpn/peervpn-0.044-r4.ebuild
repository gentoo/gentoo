# Copyright 1999-2019 Gentoo Authors
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
IUSE="libressl"
RDEPEND="libressl? ( dev-libs/libressl:0= )
	!libressl? ( <dev-libs/openssl-1.1:0= )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-${EGIT_COMMIT}

PATCHES=(
	"${FILESDIR}/${P}-strncpy-null-terminator.patch"
)

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -e 's|^CFLAGS+=-O2||' -i Makefile || die
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dosbin ${PN}

	insinto /etc/${PN}
	newins peervpn.conf peervpn.conf.example
	# read-only group access for bug 629418
	fowners root:${PN} /etc/${PN}
	fperms 0750 /etc/${PN}

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /var/log/${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}

pkg_preinst() {
	if ! has_version '>=net-vpn/peervpn-0.044-r4' && \
		[[ -d ${EROOT}etc/${PN} &&
		$(find "${EROOT}etc/${PN}" -user "${PN}" ! -type l -print) ]]; then
		ewarn "Tightening '${EROOT}etc/${PN}' permissions for bug 629418"
		while read -r -d ''; do
			chown root:${PN} "${REPLY}" || die
			chmod g+rX-w,o-rwx "${REPLY}" || die
		done < <(find "${EROOT}etc/${PN}" -user "${PN}" ! -type l -print0)
	fi
}
