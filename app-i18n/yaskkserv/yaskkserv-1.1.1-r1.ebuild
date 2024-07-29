# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs systemd

DESCRIPTION="Yet Another SKK server"
HOMEPAGE="http://umiushi.org/~wac/yaskkserv/"
SRC_URI="http://umiushi.org/~wac/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnutls systemd"

RDEPEND="app-i18n/skk-jisyo
	gnutls? ( net-libs/gnutls:= )
	!gnutls? (
		dev-libs/openssl:0=
	)
	systemd? ( sys-apps/systemd )"
DEPEND="${RDEPEND}
	dev-lang/perl"

PATCHES=( "${FILESDIR}"/${PN}-gentoo.patch )
HTML_DOCS=( documentation/. )

src_configure() {
	econf \
		$(use_enable gnutls) \
		$(use_enable systemd) \
		--compiler="$(tc-getCXX)"
}

src_install() {
	emake DESTDIR="${D}" install_all
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	systemd_dounit examples/${PN}.socket
	systemd_dounit "${FILESDIR}"/${PN}.service
}

yaskkserv_update() {
	local f
	for f in "${ROOT}"/usr/share/skk/SKK-JISYO.*; do
		case ${f} in
		*.cdb)
			;;
		*.${PN})
			[[ -f ${f%.*} ]] || rm -f "${f}"
			;;
		*)
			[[ ${f} -nt ${f}.${PN} ]] && ${PN}_make_dictionary "${f}" "${f}.${PN}"
			;;
		esac
	done
}

pkg_postinst() {
	yaskkserv_update

	elog "You need to run:"
	elog "  emerge --config =${CATEGORY}/${PF}"
	elog "after updating app-i18n/skk-jisyo from next time."
}

pkg_postrm() {
	rm -f "${ROOT}"/usr/share/skk/SKK-JISYO.*.${PN}
	rmdir "${ROOT}"/usr/share/skk 2>/dev/null
}

pkg_config() {
	yaskkserv_update
}
