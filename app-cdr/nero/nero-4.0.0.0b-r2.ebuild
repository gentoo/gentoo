# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils fdo-mime gnome2-utils linux-info rpm

DESCRIPTION="Nero Burning ROM for Linux"
HOMEPAGE="http://nerolinux.nero.com"
SRC_URI="
	x86? ( ${PN}linux-${PV}-x86.rpm )
	amd64? ( ${PN}/${PN}linux-${PV}-x86_64.rpm )"

LICENSE="Nero-EULA-US"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RESTRICT="strip mirror test fetch"

RDEPEND="
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/pango[X]"
DEPEND=""

S="${WORKDIR}"

PATCHES=( "${FILESDIR}"/${P}-qa-desktop-files.patch )

pkg_nofetch() {
	local nero_arch
	use amd64 && nero_arch=64
	use x86 && ner_arch=32

	einfo "Please visit https://www.nero.com/enu/downloads/previous-versions/download-linux4-update.php"
	einfo " and use the 'RPM package ${nero_arch} bit' download then place ${A}"
	einfo " into ${DISTDIR}"
}

pkg_setup() {
	QA_TEXTRELS="opt/${PN}/$(get_libdir)/${PN}/*
		opt/${PN}/$(get_libdir)/libNeroAPI.so"
	QA_EXECSTACK="opt/${PN}/$(get_libdir)/nero/*"
	QA_PREBUILT="opt/${PN}/${PN}.*
		opt/${PN}/${PN}
		opt/${PN}/$(get_libdir)/.*so
		opt/${PN}/$(get_libdir)/${PN}/*
		opt/${PN}/$(get_libdir)/${PN}/plug-ins/*
		usr/share/${PN}/helpers/splash/nerosplash"

	CONFIG_CHECK="~CHR_DEV_SG"
	linux-info_pkg_setup
}

src_install() {
	insinto /etc
	doins -r etc/nero

	insinto /opt/nero
	doins -r usr/$(get_libdir)
	dosym /opt/nero/$(get_libdir)/nero /usr/$(get_libdir)/nero

	exeinto /opt/nero
	doexe usr/bin/nero*

	insinto /usr/share
	doins -r usr/share/nero usr/share/locale usr/share/icons

	domenu usr/share/applications/*.desktop
	doicon usr/share/pixmaps/nerolinux.xpm

	doman usr/share/man/man1/*

	use doc && local DOCS+=( usr/share/doc/nero/*.pdf )
	einstalldocs

	make_wrapper nero ./nero /opt/nero /opt/${PN}/$(get_libdir)
	make_wrapper nerocmd ./nerocmd /opt/nero /opt/nero/$(get_libdir)
	make_wrapper neroexpress ./neroexpress /opt/nero /opt/nero/$(get_libdir)

	# This is a ugly hack to fix burning in x86_64
	# http://club.cdfreaks.com/showthread.php?t=218041
	if use amd64; then
		cp usr/share/nero/Nero*.txt "${ED%/}"/opt/nero/$(get_libdir)/nero || die
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update

	nero --perform-post-installation || die
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
