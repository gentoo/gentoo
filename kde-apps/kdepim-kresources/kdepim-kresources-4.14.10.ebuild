# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
KMMODULE="kresources"
inherit kde4-meta

DESCRIPTION="KDE PIM groupware plugin collection"
IUSE="debug"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"

DEPEND="
	$(add_kdeapps_dep kdepimlibs 'akonadi(+)')
	$(add_kdeapps_dep kdepim-common-libs)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	kmail/
	knotes/
	korganizer/version.h
"

KMLOADLIBS="kdepim-common-libs"
