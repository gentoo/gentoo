# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs systemd

DESCRIPTION="Yet Another SKK server"
HOMEPAGE="http://umiushi.org/~wac/yaskkserv/"
SRC_URI="http://umiushi.org/~wac/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="gnutls libressl systemd"

RDEPEND="app-i18n/skk-jisyo
	gnutls? ( net-libs/gnutls )
	!gnutls? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)
	systemd? ( virtual/udev[systemd] )"
DEPEND="${RDEPEND}
	dev-lang/perl"

REQUIRED_USE="?? ( gnutls libressl )"

PATCHES=( "${FILESDIR}"/${PN}-gentoo.patch )
DOCS=( README.md )
HTML_DOCS=( documentation/. )

src_configure() {
	econf \
		$(use_enable gnutls) \
		$(use_enable systemd) \
		--compiler="${tc_getCXX}"
}

src_install() {
	emake DESTDIR="${D}" install_all
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	systemd_dounit examples/${PN}.socket
	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_postinst() {
	pkg_config

	elog "You need to run:"
	elog "  emerge --config =${CATEGORY}/${PF}"
	elog "after updating app-i18n/skk-jisyo from next time."
}

pkg_postrm() {
	rm -f "${ROOT}"/usr/share/skk/SKK-JISYO.*.${PN}
	rmdir "${ROOT}"/usr/share/skk 2>/dev/null
}

pkg_config() {
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
