# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Address book API based on KDE Frameworks"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_qt_dep qtgui)
"
RDEPEND="${DEPEND}
	!kde-apps/kcontacts:5
	!kde-apps/kdepim-l10n
	app-text/iso-codes
"

src_test() {
	# bug #566648 (access to /dev/dri/card0 denied), bug #625988
	local myctestargs=(
		-E "(kcontacts-addresstest|kcontacts-picturetest)"
	)
	kde5_src_test
}
