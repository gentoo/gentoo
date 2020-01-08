# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

VERSION="2028" # every bump, new version!

DESCRIPTION="VDR Plugin: burn records on DVD"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-burn"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="dvdarchive"

DEPEND="media-libs/gd[png,truetype,jpeg]
		media-video/vdr"
RDEPEND="${DEPEND}
		app-cdr/dvd+rw-tools
		dev-libs/libcdio
		media-fonts/corefonts
		media-video/dvdauthor
		media-video/mjpegtools[png]
		media-video/projectx
		media-video/transcode
		virtual/eject"

# depends that are not rdepend
DEPEND="${DEPEND}
		dev-libs/boost"

S="${WORKDIR}/${P#vdr-}"

src_prepare() {
	vdr-plugin-2_src_prepare

	eapply \
		"${FILESDIR}"/${P}_gentoo-path.patch \
		"${FILESDIR}"/${P}_setdefaults.patch \
		"${FILESDIR}"/${P}_dmh-archive.patch

	use dvdarchive && sed -i Makefile \
		-e "s:#ENABLE_DMH_ARCHIVE:ENABLE_DMH_ARCHIVE:"

	sed -i Makefile \
		-e 's:^ISODIR=.*$:ISODIR=/var/vdr/video/dvd-images:'

	sed -i Makefile -e 's:DEFINES += -DTTXT_SUBTITLES:#DEFINES += -DTTXT_SUBTITLES:'

	# do not install deprecated fonts, do not install in /etc/vdr/plugin config dir
	sed -i Makefile \
		-e "s:install-res install-conf::"

	# ttf-bitstream-vera deprecated, bug #335782
	sed -e "s:Vera:arial:" -i skins.c

	# fix deprecated warnings pkg-config
	sed -i Makefile \
		-e "s:gdlib-config:pkg-config gdlib:"

	fix_vdr_libsi_include scanner.c
}

src_install() {
	vdr-plugin-2_src_install

	insinto /usr/share/vdr/burn
	doins "${S}"/resource/menu-silence.mp2
	newins "${S}"/resource/menu-button.png menu-button-default.png
	newins "${S}"/resource/menu-bg.png menu-bg-default.png

	newins "${S}"/config/ProjectX.ini projectx-vdr.ini

	dosym "${EPREFIX}"menu-bg-default.png "${EPREFIX}"/usr/share/vdr/burn/menu-bg.png
	dosym "${EPREFIX}"menu-button-default.png "${EPREFIX}"/usr/share/vdr/burn/menu-button.png

	insinto /usr/share/vdr/burn/counters/
	doins "${S}/config/counters/standard"

	fowners -R vdr:vdr /usr/share/vdr/burn
}

pkg_preinst() {
	if [[ -d ${EROOT}/etc/vdr/plugins/burn && ( ! -L ${EROOT}/etc/vdr/plugins/burn ) ]]; then
		einfo "Moving /etc/vdr/plugins/burn away"
		mv "${EROOT}"/etc/vdr/plugins/burn "${EROOT}"/etc/vdr/plugins/burn_old
	fi
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	if [[ -e ${EROOT}/etc/vdr/reccmds/reccmds.burn.conf ]]; then
		eerror "\nPlease remove the following unneeded file:"
		eerror "\t/etc/vdr/reccmds/reccmds.burn.conf\n"
	fi
}
