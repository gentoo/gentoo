# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils

# get the major version from PV
MV=${PV:0:1}

DESCRIPTION="Sophisticated text editor for code, markup and prose"
HOMEPAGE="http://www.sublimetext.com"
SRC_URI="
	amd64? ( https://download.sublimetext.com/Sublime%20Text%20${PV}%20x64.tar.bz2 -> ${P}_x64.tar.bz2 )
	x86? ( https://download.sublimetext.com/Sublime%20Text%20${PV}.tar.bz2 -> ${P}_x32.tar.bz2 )"

LICENSE="Sublime"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus"
RESTRICT="bindist mirror strip"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/libX11
	dbus? ( sys-apps/dbus )"

QA_PREBUILT="*"
S="${WORKDIR}/Sublime Text ${MV}"

# Sublime bundles the kitchen sink, which includes python and other assorted
# modules. Do not try to unbundle these because you are guaranteed to fail.

src_install() {
	insinto /opt/${PN}${MV}
	doins -r "Pristine Packages" lib
	doins sublime_plugin.py PackageSetup.py

	exeinto /opt/${PN}${MV}
	doexe sublime_text
	dosym ../../opt/${PN}${MV}/sublime_text /usr/bin/subl

	local size
	for size in 16 32 48 128 256; do
		newicon -s ${size} Icon/${size}x${size}/sublime_text.png subl.png
	done

	make_desktop_entry "subl" "Sublime Text ${MV}" "subl" \
		"TextEditor;IDE;Development" "StartupNotify=true"

	# needed to get WM_CLASS lookup right
	mv "${ED%/}"/usr/share/applications/subl{-sublime-text,}.desktop || die
}

pkg_postrm() {
	gnome2_icon_cache_update
}

pkg_postinst() {
	gnome2_icon_cache_update
}
