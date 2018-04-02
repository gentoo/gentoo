# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="PackageKit Package Manager interface (meta package)"
HOMEPAGE="https://www.freedesktop.org/software/PackageKit/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gtk qt5"

RDEPEND="gtk? ( ~app-admin/packagekit-gtk-${PV} )
	qt5? ( >=app-admin/packagekit-qt-0.9.6 )"

DEPEND="${RDEPEND}"
