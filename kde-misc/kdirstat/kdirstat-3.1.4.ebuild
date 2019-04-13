# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="GUI equivalent to the du command based on KDE Frameworks"
HOMEPAGE="https://bitbucket.org/jeromerobert/k4dirstat/"
SRC_URI="https://bitbucket.org/jeromerobert/k4dirstat/get/k4dirstat-${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

BDEPEND="
	sys-devel/gettext
"
DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_unpack() {
	# tarball contains git revision hash, which we don't want in the ebuild.
	default
	mv "${WORKDIR}"/*k4dirstat-* "${S}" || die
}
