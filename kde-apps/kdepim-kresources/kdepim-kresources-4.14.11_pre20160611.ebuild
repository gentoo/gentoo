# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kdepim"
KMMODULE="kresources"
inherit kde4-meta

DESCRIPTION="KDE PIM groupware plugin collection"

IUSE="debug"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"

DEPEND="
	$(add_kdeapps_dep kdepim-common-libs)
	$(add_kdeapps_dep kdepimlibs)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	kmail/
	knotes/
	korganizer/version.h
"

KMLOADLIBS="kdepim-common-libs"
