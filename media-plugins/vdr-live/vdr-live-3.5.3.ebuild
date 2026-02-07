# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature ssl-cert vdr-plugin-2

DESCRIPTION="VDR Plugin: Web Access To Settings"
HOMEPAGE="https://github.com/MarkusEh/vdr-plugin-live"
SRC_URI="https://github.com/MarkusEh/vdr-plugin-live/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-live-${PV}"

LICENSE="Apache-2.0 GPL-2+ RSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-video/vdr:=
	>=dev-libs/cxxtools-3
	>=dev-libs/tntnet-3[ssl=]"
DEPEND="${RDEPEND}"
BDEPEND="
	acct-user/vdr
	sys-apps/which"

KEEP_I18NOBJECT="yes"
QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-live.*
	usr/lib64/vdr/plugins/libvdr-live.*"
LIVE_SSL_KEY_DIR="/etc/vdr/plugins/live"

make_live_cert() {
	elog "Create and install SSL certificate"
	SSL_ORGANIZATION="VDR Plugin Live"
	SSL_COMMONNAME=$("${ROOT}"/bin/hostname -f)
	elog "install_cert ${LIVE_SSL_KEY_DIR}/live for host $SSL_COMMONNAME"
	rm -f "${ROOT}${LIVE_SSL_KEY_DIR}/live.pem" "${ROOT}${LIVE_SSL_KEY_DIR}/live-key.pem" || die
	install_cert "${ROOT}${LIVE_SSL_KEY_DIR}/live"
	ls -la "${ROOT}${LIVE_SSL_KEY_DIR}/"
	rm -f "${ROOT}${LIVE_SSL_KEY_DIR}/live.csr" || die
	mv "${ROOT}${LIVE_SSL_KEY_DIR}/live.key" "${ROOT}${LIVE_SSL_KEY_DIR}/live-key.pem" || die
	mv "${ROOT}${LIVE_SSL_KEY_DIR}/live.crt" "${ROOT}${LIVE_SSL_KEY_DIR}/live.pem" || die
	chown vdr:vdr "${ROOT}${LIVE_SSL_KEY_DIR}/live.pem" || die
	chown vdr:vdr "${ROOT}${LIVE_SSL_KEY_DIR}/live-key.pem" || die
}

src_install() {
	vdr-plugin-2_src_install

	insinto /usr/share/vdr/plugins/live
	doins -r live/*
	fowners -R vdr:vdr /usr/share/vdr/plugins/live
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	optfeature "to search the EPG" media-plugins/vdr-epgsearch
	optfeature "for Live-TV streaming" media-plugins/vdr-streamdev
	elog "The default username/password is:"
	elog "\tadmin:live"

	if use ssl; then
		# only create a certificate if none exists
		if [[ -f ${ROOT}${LIVE_SSL_KEY_DIR}/live.pem ]]; then
			elog "Existing SSL cert found, not touching it."
			elog "To create a new SSL cert, execute command:"
			elog "\temerge --config ${PN}"
		else
			elog "No SSL cert found, creating a default one now"
			make_live_cert
		fi
	fi
}

pkg_config() {
	make_live_cert
}
