# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vdr-plugin-2 ssl-cert

MY_P="release_2-3-1"

DESCRIPTION="VDR Plugin: Web Access To Settings"
HOMEPAGE="http://live.vdr-developer.org"
SRC_URI="https://projects.vdr-developer.org/git/vdr-plugin-live.git/snapshot/${MY_P}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2 RSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pcre ssl"

DEPEND="media-video/vdr
	>=dev-libs/tntnet-2.2.1[ssl=]
	>=dev-libs/cxxtools-2.2.1
	pcre? ( >=dev-libs/libpcre-8.12[cxx] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

VDR_CONFD_FILE="${FILESDIR}/confd-2.3"
VDR_RCADDON_FILE="${FILESDIR}/rc-addon-2.3.sh"

KEEP_I18NOBJECT="yes"

make_live_cert() {
	# TODO: still true?
	# ssl-cert eclass creates a "invalid" cert, create our own one
	local base=$(get_base 1)
	local keydir="/etc/vdr/plugins/live"

	SSL_ORGANIZATION="${SSL_ORGANIZATION:-VDR Plugin Live}"
	SSL_COMMONNAME="${SSL_COMMONNAME:-`hostname -f`}"

	echo
	gen_cnf || return 1
	echo
	gen_key 1 || return 1
	gen_csr 1 || return 1
	gen_crt 1 || return 1
	echo

	install -d "${ROOT}${keydir}"
	install -m0400 "${base}.key" "${ROOT}${keydir}/live-key.pem"
	install -m0444 "${base}.crt" "${ROOT}${keydir}/live.pem"
	chown vdr:vdr "${ROOT}"/etc/vdr/plugins/live/live{,-key}.pem
}

src_prepare() {
	# remove untranslated language files
	rm "${S}"/po/{ca_ES,da_DK,el_GR,et_EE,hr_HR,hu_HU,nl_NL,nn_NO,pt_PT,ro_RO,sl_SI,tr_TR}.po

	vdr-plugin-2_src_prepare

	if ! use pcre; then
		sed -i "s:^HAVE_LIBPCRECPP:#HAVE_LIBPCRECPP:" Makefile || die
	fi
}

src_install() {
	vdr-plugin-2_src_install

	insinto /usr/share/vdr/plugins/live
	doins -r live/*

	fowners -R vdr:vdr /usr/share/vdr/plugins/live
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	elog "To be able to use all functions of vdr-live"
	elog "you should emerge and enable"
	elog "media-plugins/vdr-epgsearch to search the EPG,"
	elog "media-plugins/vdr-streamdev for Live-TV streaming"

	elog "The default username/password is:"
	elog "\tadmin:live"

	if use ssl ; then
		if [[ -f ${ROOT}/etc/vdr/plugins/live/live.pem ]]; then
			einfo "found an existing SSL cert, to create a new SSL cert, run:\n"
			einfo "emerge --config ${PN}"
		else
			einfo "No SSL cert found, creating a default one now"
			make_live_cert
		fi
	fi
}

pkg_config() {
	make_live_cert
}
