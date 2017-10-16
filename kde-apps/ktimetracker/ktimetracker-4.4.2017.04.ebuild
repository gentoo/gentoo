# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
QT3SUPPORT_REQUIRED="true"
inherit kde4-meta

DESCRIPTION="Tracks time spent on various tasks (noakonadi branch)"
HOMEPAGE="https://launchpad.net/~pali/+archive/ubuntu/kdepim-noakonadi"

KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep kdepim-kresources)
	$(add_kdeapps_dep kdepimlibs)
	$(add_kdeapps_dep libkdepim)
	x11-libs/libXScrnSaver
"
DEPEND="${RDEPEND}
	x11-proto/scrnsaverproto
"

KMEXTRACTONLY="
	kresources/
"

KMLOADLIBS="libkdepim"

PATCHES=( "${FILESDIR}/${P}-gcc-6.3.patch" )

src_unpack() {
	if use kontact; then
		KMEXTRA="${KMEXTRA} kontact/plugins/ktimetracker"
	fi

	kde4-meta_src_unpack
}
