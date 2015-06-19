# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/lotus-notes/lotus-notes-8.5.3.ebuild,v 1.6 2015/06/18 18:52:39 ulm Exp $

EAPI=5

inherit rpm

DESCRIPTION="Commercial fork of openoffice.org with extra features for company usage"
HOMEPAGE="http://www.ibm.com/software/products/us/en/ibmnotes/"
SRC_URI="lotus_notes853_linux_RI_en.tar
	http://dev.gentooexperimental.org/~scarabeus/lotus-notes-gtk-patch-20130622.tar.xz
"

LICENSE="lotus-notes"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	x86? (
		dev-libs/dbus-glib
		dev-libs/libcroco
		gnome-base/gconf
		gnome-base/libgnome
		gnome-base/libgnomeprint
		gnome-base/libgnomeprintui
		gnome-base/gvfs
		gnome-base/librsvg
		gnome-base/orbit
		gnome-extra/gconf-editor
		gnome-extra/libgsf
		net-dns/avahi
		x11-libs/gdk-pixbuf
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXScrnSaver
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXft
		x11-libs/libXi
		x11-libs/libXp
		x11-libs/libXrender
		x11-libs/libXt
		x11-libs/libXtst
		x11-libs/libxkbfile
		x11-libs/pango
		x11-themes/gtk-engines-murrine
	)
	dev-java/swt
	dev-libs/dbus-glib
	dev-libs/icu
	sys-apps/dbus[X]
"
DEPEND="${RDEPEND}"

RESTRICT="mirror fetch strip"

QA_PREBUILT="opt/ibm/lotus/notes/*"
QA_TEXTRELS="opt/ibm/lotus/notes/*"

S=${WORKDIR}

src_unpack() {
	default
	rpm_unpack ./ibm_lotus_notes-${PV}.i586.rpm
}

src_prepare() {
	sed -i \
		-e 's/..\/notes %F/..\/notes-wrapper %F/g' \
		-e 's:Office;:Office:g' \
		usr/share/applications/LotusNotes8.5.desktop || die
	sed -i \
		-e 's:Application;Office:Office;:g' \
		usr/share/applications/* || die
	sed -i \
		-e 's:`dirname "$0"`:/opt/ibm/lotus/notes/:' \
		lotus-notes-gtk-patch/notes-wrapper || die
	# force initial configuration to avoid overwritting configs in /opt/
	sed -i \
		-e '/.initial./d' \
		opt/ibm/lotus/notes/framework/rcp/rcplauncher.properties || die
}

src_compile() {
	# generate the gtk-fix for the notes to actually work with current gtk/gnome3
	cd "${S}/lotus-notes-gtk-patch" || die
	emake
}

src_install() {
	cp -r usr/ opt "${ED}" || die
	cd "${S}/lotus-notes-gtk-patch" || die
	cp notes-wrapper libnotesgtkfix.so "${ED}"/opt/ibm/lotus/notes/ || die

	dosym /opt/ibm/lotus/notes/notes-wrapper /usr/bin/lotus-notes
}

pkg_postinst() {
	elog "Keep in mind that Lotus notes are slowly merged back into"
	elog "Apache OpenOffice and LibreOffice as IBM promised to provide"
	elog "all the code to Apache Foundation."
	elog
	elog "If you will report bugs against this package provide also"
	elog "patches or the bug will be probably ignored or closed as"
	elog "CANTFIX."
}
