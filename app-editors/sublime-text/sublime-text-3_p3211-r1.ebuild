# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

# get the major version from PV
MV=${PV:0:1}
MY_PV=${PV#*_p}

DESCRIPTION="Sophisticated text editor for code, markup and prose"
HOMEPAGE="https://www.sublimetext.com"
SRC_URI="
	amd64? ( https://download.sublimetext.com/sublime_text_${MV}_build_${MY_PV}_x64.tar.bz2 )
	x86? ( https://download.sublimetext.com/sublime_text_${MV}_build_${MY_PV}_x32.tar.bz2 )"

LICENSE="Sublime"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus"
RESTRICT="bindist mirror strip"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:3
	x11-libs/libX11
	dbus? ( sys-apps/dbus )"

QA_PREBUILT="*"
S="${WORKDIR}/sublime_text_${MV}"

# Sublime bundles the kitchen sink, which includes python and other assorted
# modules. Do not try to unbundle these because you are guaranteed to fail.

src_install() {
	insinto /opt/${PN}${MV}
	doins -r Packages Icon
	doins changelog.txt sublime_plugin.py sublime.py python3.3.zip

	exeinto /opt/${PN}${MV}
	doexe crash_reporter plugin_host sublime_text
	dosym ../../opt/${PN}${MV}/sublime_text /usr/bin/subl

	local size
	for size in 16 32 48 128 256; do
		dosym ../../../../../../opt/${PN}${MV}/Icon/${size}x${size}/sublime-text.png \
			/usr/share/icons/hicolor/${size}x${size}/apps/subl.png
	done

	make_desktop_entry "subl %F" "Sublime Text ${MV}" subl \
		"TextEditor;IDE;Development" "StartupNotify=true"

	# needed to get WM_CLASS lookup right
	mv "${ED}"/usr/share/applications/subl{_%F-sublime-text,}.desktop || die
}

pkg_postrm() {
	xdg_icon_cache_update
}

pkg_postinst() {
	xdg_icon_cache_update
}
