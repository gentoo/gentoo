# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="Library for interacting with IMAP servers"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

# TODO: Convince upstream not to install stuff with tests
CDEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_kdeapps_dep kmime)
	$(add_qt_dep qtgui)
	dev-libs/cyrus-sasl
"
DEPEND="${CDEPEND}
	test? ( $(add_qt_dep qttest) )
"
RDEPEND="${CDEPEND}
	!kde-apps/kdepim-l10n
"

src_test() {
	# tests cannot be run in parallel #605586
	local myctestargs=(
		-j1
	)

	kde5_src_test
}
