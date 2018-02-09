# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/jedisct1/dnscrypt-proxy/..."
EGO_SRC="github.com/jedisct1/dnscrypt-proxy"

inherit systemd user golang-build

DESCRIPTION="A flexible DNS proxy, with support for modern encrypted DNS protocols."
HOMEPAGE="https://${EGO_PN}"
SRC_URI="https://${EGO_PN}/archive/2.0.0.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="systemd"

RDEPEND="systemd? ( sys-apps/systemd )"

S="${WORKDIR}/${P}"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.0_fix_systemd_service.patch"
)

pkg_setup() {
	enewgroup dnscrypt
	enewuser dnscrypt -1 -1 /var/empty dnscrypt
}

src_prepare() {
	default
	cd "${PN}"
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" go get -u -f "${EGO_PN}"
}

src_compile() {
	cd "${PN}"
	golang-build_src_compile
	default
}

src_install() {
	local DOCS=( README* "${PN}"/example-* )

	default

	newinitd "${FILESDIR}/${PN}.initd-2" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd-2" "${PN}"

	exeinto "/usr/sbin"
	doexe "bin/${PN}"

	systemd_dounit "systemd/${PN}.service"
	systemd_dounit "systemd/${PN}.socket"

	insinto "/etc/${PN}"
	newins "${PN}/example-blacklist.txt" "blacklist.txt"
	newins "${PN}/example-cloaking-rules.txt" "cloaking-rules.txt"
	newins "${PN}/example-dnscrypt-proxy.toml" "dnscrypt-proxy.toml"
	newins "${PN}/example-forwarding-rules.txt" "forwarding-rules.txt"

	insinto "/usr/share/${PN}"
	doins -r "utils/generate-domains-blacklists/"
}

pkg_postinst() {
	elog "After starting the service you will need to update your"
	elog "/etc/resolv.conf and replace your current set of resolvers"
	elog "with:"
	elog
	elog "nameserver 127.0.0.1"
	elog
	use systemd && elog "with systemd dnscrypt-proxy you must set listen_addresses setting to \"[]\" in the config file"
	use systemd && elog "edit dnscrypt-proxy.socket if you need to change the defaults port and address"
	elog
	elog "Also see https://github.com/jedisct1/dnscrypt-proxy#usage."
}
