# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-burn/vdr-burn-0.2.2-r1.ebuild,v 1.1 2015/03/01 13:09:00 hd_brummy Exp $

EAPI="5"

inherit vdr-plugin-2

VERSION="1252" # every bump, new version!

DESCRIPTION="VDR Plugin: burn records on DVD"
HOMEPAGE="http://projects.vdr-developer.org/projects/show/plg-burn"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="dvdarchive"

DEPEND=">=media-video/vdr-1.7.36-r1
		media-libs/gd[png,truetype,jpeg]"
RDEPEND="${DEPEND}
		>=dev-libs/libcdio-0.71
		>=media-video/dvdauthor-0.6.14
		>=media-video/mjpegtools-1.6.2[png]
		media-video/transcode
		media-fonts/corefonts
		virtual/eject
		>=app-cdr/dvd+rw-tools-5.21
		>=media-video/projectx-0.90.4.00_p32
		dvdarchive? ( media-video/vdrtools-genindex )"

# depends that are not rdepend
DEPEND="${DEPEND}
		>=dev-libs/boost-1.32.0"

S="${WORKDIR}/${P#vdr-}"

src_prepare() {
	vdr-plugin-2_src_prepare

	epatch \
		"${FILESDIR}"/${P}-r1_gentoo-path.diff \
		"${FILESDIR}"/${P}_setdefaults.diff \
		"${FILESDIR}"/${P}_makefile.diff \
		"${FILESDIR}"/${P}-missing-include-for-function-setpriority.patch

	use dvdarchive && sed -i Makefile \
		-e "s:#ENABLE_DMH_ARCHIVE:ENABLE_DMH_ARCHIVE:"

	sed -i Makefile \
		-e 's:^ISODIR=.*$:ISODIR=/var/vdr/video/dvd-images:'

	sed -i Makefile -e 's:DEFINES += -DTTXT_SUBTITLES:#DEFINES += -DTTXT_SUBTITLES:'

	if has_version ">=media-video/vdr-2.1.2"; then
		sed -e "s#VideoDirectory#cVideoDirectory::Name\(\)#" \
		-i jobs.c
	fi

	# ttf-bitstream-vera deprecated, bug #335782
	sed -e "s:Vera:arial:" -i skins.c

	fix_vdr_libsi_include scanner.c
}

src_install() {
	vdr-plugin-2_src_install

	dobin "${S}"/*.sh

	insinto /usr/share/vdr/burn
	doins "${S}"/burn/menu-silence.mp2
	newins "${S}"/burn/menu-button.png menu-button-default.png
	newins "${S}"/burn/menu-bg.png menu-bg-default.png
	dosym menu-bg-default.png /usr/share/vdr/burn/menu-bg.png
	dosym menu-button-default.png /usr/share/vdr/burn/menu-button.png

	newins "${S}"/burn/ProjectX.ini projectx-vdr.ini

	fowners -R vdr:vdr /usr/share/vdr/burn

	(
		diropts -ovdr -gvdr
		keepdir /usr/share/vdr/burn/counters
	)
}

pkg_preinst() {
	if [[ -d ${ROOT}/etc/vdr/plugins/burn && ( ! -L ${ROOT}/etc/vdr/plugins/burn ) ]]; then
		einfo "Moving /etc/vdr/plugins/burn away"
		mv "${ROOT}"/etc/vdr/plugins/burn "${ROOT}"/etc/vdr/plugins/burn_old
	fi
}

pkg_postinst() {

	local DMH_FILE="${ROOT}/usr/share/vdr/burn/counters/standard"
	if [[ ! -e "${DMH_FILE}" ]]; then
		echo 0001 > "${DMH_FILE}"
		chown vdr:vdr "${DMH_FILE}"
	fi

	vdr-plugin-2_pkg_postinst

	einfo
	einfo "This ebuild comes only with the standard template"
	einfo "'emerge vdr-burn-templates' for more templates"
	einfo "To change the templates, use the vdr-image plugin"

	if [[ -e ${ROOT}/etc/vdr/reccmds/reccmds.burn.conf ]]; then
		eerror
		eerror "Please remove the following unneeded file:"
		eerror "\t/etc/vdr/reccmds/reccmds.burn.conf"
		eerror
	fi
}
