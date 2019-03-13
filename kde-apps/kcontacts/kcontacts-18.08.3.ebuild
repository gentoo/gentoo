# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Address book API based on KDE Frameworks"
LICENSE="GPL-2+"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_qt_dep qtgui)
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
"

src_test() {
	mkdir -p "${HOME}/.local/share/kf5/kcontacts" || die
	cp "${S}/src/countrytransl.map" "${HOME}/.local/share/kf5/kcontacts/" || die
	# bug #566648 (access to /dev/dri/card0 denied)
	local myctestargs=(
		-E "(kcontacts-picturetest)"
	)
	kde5_src_test
}
