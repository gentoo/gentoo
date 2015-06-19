# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/google-musicmanager/google-musicmanager-1.0.129.6633_beta.ebuild,v 1.4 2015/04/18 18:43:16 ottxor Exp $

EAPI=5

inherit eutils unpacker

#http://dl.google.com/linux/musicmanager/deb/dists/stable/main/binary-i386/Packages
MY_URL="http://dl.google.com/linux/musicmanager/deb/pool/main/${P:0:1}/${PN}-beta"
MY_PKG="${PN}-beta_${PV/_beta}-r0_i386.deb"

DESCRIPTION="Google Music Manager is a application for adding music to your Google Music library"
HOMEPAGE="http://music.google.com"
SRC_URI="x86? ( ${MY_URL}/${MY_PKG} )
	amd64? ( ${MY_URL}/${MY_PKG/i386/amd64} )"

LICENSE="Google-TOS Apache-2.0 MIT LGPL-2.1 gSOAP BSD FDL-1.2 MPL-1.1 openssl ZLIB libtiff"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="log"

OBSOLETE="yes"
[[ $OBSOLETE = yes ]] && RESTRICT="fetch strip" || RESTRICT="strip mirror"

RDEPEND="
	dev-libs/expat
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4
	media-libs/flac
	media-libs/libvorbis
	net-dns/libidn
	sys-libs/glibc
	log? ( dev-libs/log4cxx )
	"

DEPEND="app-arch/xz-utils
	app-admin/chrpath"

INSTALL_BASE="opt/google/musicmanager"

QA_TEXTRELS="${INSTALL_BASE}/libmpgdec.so.0"

QA_FLAGS_IGNORED="${INSTALL_BASE}/.*"

S="${WORKDIR}/${INSTALL_BASE}"

pkg_nofetch() {
	if [[ ${OBSOLETE} = yes ]]; then
		elog "This version is no longer available from Google and the license prevents mirroring."
		elog "This ebuild is intended for users who already downloaded it previously and have problems"
		elog "with ${PV}+. If you can get the distfile from e.g. another computer of yours, or search"
		use amd64 && MY_PKG="${MY_PKG/i386/amd64}"
		elog "it with google: http://www.google.com/search?q=intitle:%22index+of%22+${MY_PKG}"
		elog "and copy the file ${MY_PKG} to ${DISTDIR}."
	else
		einfo "This version is no longer available from Google."
		einfo "Note that Gentoo cannot mirror the distfiles due to license reasons, so we have to follow the bump."
		einfo "Please file a version bump bug on http://bugs.gentoo.org (search	existing bugs for ${PN} first!)."
	fi
}

src_install() {
	insinto "/${INSTALL_BASE}"
	doins config.json product_logo* lang.*.qm

	exeinto "/${INSTALL_BASE}"
	chrpath -d MusicManager || die
	doexe MusicManager google-musicmanager minidump_upload
	#TODO unbundle this
	doexe libaacdec.so libaudioenc.so.0 libmpgdec.so.0 libid3tag.so

	dosym /"${INSTALL_BASE}"/google-musicmanager /opt/bin/google-musicmanager

	local icon size
	for icon in product_logo_*.png; do
		size=${icon#product_logo_}
		size=${size%.png}
		newicon -s "${size}" "${icon}" ${PN}.png
	done
	domenu ${PN}.desktop
}
