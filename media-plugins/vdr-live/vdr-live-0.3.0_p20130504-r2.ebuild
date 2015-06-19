# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-live/vdr-live-0.3.0_p20130504-r2.ebuild,v 1.1 2015/01/28 14:56:35 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2 ssl-cert

DESCRIPTION="VDR Plugin: Web Access To Settings"
HOMEPAGE="http://live.vdr-developer.org"
SRC_URI="mirror://gentoo/${P}.tar.bz2
		http://dev.gentoo.org/~hd_brummy/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pcre ssl"

DEPEND="media-video/vdr
	>=dev-libs/tntnet-2.2.1[ssl=]
	>=dev-libs/cxxtools-2.2.1
	pcre? ( >=dev-libs/libpcre-8.12[cxx] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}"

VDR_CONFD_FILE="${FILESDIR}/confd-0.3"
VDR_RCADDON_FILE="${FILESDIR}/rc-addon-0.3.sh"

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

src_configure() {
	# tmp. disabled gcc -std=c++11, due massiv compile errors
	filter-flags -std=c++11
}

src_prepare() {
	# new Makefile handling ToDp
#	cp "${FILESDIR}/live.mk" "${S}/Makefile"

	# remove untranslated language files
	rm "${S}"/po/{ca_ES,da_DK,el_GR,et_EE,hr_HR,hu_HU,nl_NL,nn_NO,pt_PT,ro_RO,ru_RU,sl_SI,sv_SE,tr_TR}.po

	vdr-plugin-2_src_prepare

	epatch "${FILESDIR}/${P}_vdr-2.1.2.diff"

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
		if path_exists -a "${ROOT}"/etc/vdr/plugins/live/live.pem; then
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
