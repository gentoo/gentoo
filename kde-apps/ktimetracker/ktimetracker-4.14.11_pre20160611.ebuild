# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="Tracks time spent on various tasks"
HOEMPAGE="https://www.kde.org/applications/utilities/ktimetracker/"

KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep kdepim-common-libs)
	$(add_kdeapps_dep kdepim-kresources)
	$(add_kdeapps_dep kdepimlibs)
	x11-libs/libXScrnSaver
"
DEPEND="${RDEPEND}
	x11-proto/scrnsaverproto
"

KMEXTRACTONLY="
	kresources/
"

KMLOADLIBS="kdepim-common-libs"

src_unpack() {
	if use kontact; then
		KMEXTRA="${KMEXTRA} kontact/plugins/ktimetracker"
	fi

	kde4-meta_src_unpack
}
