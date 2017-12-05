# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kde-runtime"
KMNOMODULE="true"
inherit kde4-meta

DESCRIPTION="Icons, localization data and various .desktop files from kdebase"
IUSE=""
KEYWORDS="amd64 x86"

RDEPEND="
	x11-themes/hicolor-icon-theme
"

KMEXTRA="
	l10n/
	localization/
	pics/
"
# Note that the eclass doesn't do this for us, because of KMNOMODULE="true".
KMEXTRACTONLY="
	config-runtime.h.cmake
	kde4
"

src_configure() {
	# Remove remnants of hicolor-icon-theme
	sed -e "s:add_subdirectory[[:space:]]*([[:space:]]*hicolor[[:space:]]*):#donotwant:g" \
		-i pics/CMakeLists.txt \
		|| die "failed to remove remnants of hicolor-icon-theme"

	kde4-meta_src_configure
}
