# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/matchbox-desktop-image-browser/matchbox-desktop-image-browser-0.2-r1.ebuild,v 1.4 2014/08/10 20:02:29 slyfox Exp $

inherit versionator eutils autotools

MY_PN=${PN/matchbox/mb}
MY_P=${MY_PN}-${PV}

DESCRIPTION="An alpha-ish image browser plug in for matchbox-desktop"
HOMEPAGE="http://matchbox-project.org/"
SRC_URI="http://matchbox-project.org/sources/${MY_PN}/$(get_version_component_range 1-2)/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="amd64 ~arm x86"
IUSE="debug"

RDEPEND=">=x11-libs/libmatchbox-1.1"
DEPEND="${RDEPEND} x11-wm/matchbox-desktop"

S="${WORKDIR}/${MY_P}"

src_unpack () {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/$P-include_fix.patch
	epatch "${FILESDIR}"/$P-noexec-matchbox-desktop.patch
	epatch "${FILESDIR}"/$P-plugin-location-fix.patch

	eautoreconf
}

src_compile () {
	econf $(use_enable debug) || die "Configuration failed"

	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS ChangeLog INSTALL NEWS README
}

pkg_postinst() {
	einfo "To use this matchbox-desktop module:"
	einfo
	einfo "Add an entry to you mbdesktop_modules file specifying the module and"
	einfo "where your browsed images live."
	einfo
	einfo 'Ej: $ echo "/usr/lib/matchbox/desktop/imgbrowser.so ${HOME}/Pictures" >> \\'
	einfo '		~/.matchbox/mbdesktop_modules'
}
