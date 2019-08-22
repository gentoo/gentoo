# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="Write hybrid ISO files onto a USB disk"
HOMEPAGE="http://wiki.rosalab.com/en/index.php/Blog:ROSA_Planet/ROSA_Image_Writer"
[[ ${PV} != *9999* ]] && SRC_URI="mirror://kde/unstable/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	app-crypt/gpgme[cxx,qt5]
	virtual/libudev:=
"
RDEPEND="${DEPEND}"
