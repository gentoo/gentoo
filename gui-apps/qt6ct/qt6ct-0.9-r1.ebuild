# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake eapi9-ver

DESCRIPTION="Qt6 Configuration Tool (for DE/WM without Qt integration)"
HOMEPAGE="https://github.com/trialuser02/qt6ct/"
SRC_URI="https://github.com/trialuser02/qt6ct/releases/download/${PV}/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64"

# uses Qt private APIs wrt :=
# dlopen: qtsvg
DEPEND="
	dev-qt/qtbase:6=[gui,widgets]
"
RDEPEND="
	${DEPEND}
	dev-qt/qtsvg:6
"
BDEPEND="
	dev-qt/qtbase:6
	dev-qt/qttools:6[linguist]
"

src_install() {
	cmake_src_install

	# can replace after qt5ct is gone
#	newenvd - 98${PN} <<<'QT_QPA_PLATFORMTHEME=qt6ct'
	newenvd - 98${PN} <<-EOF
		# 'qt5ct' is recognized by both qt5ct and qt6ct to allow simultaneous usage
		QT_QPA_PLATFORMTHEME=qt5ct
	EOF
}

pkg_postinst() {
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog
		elog "QT_QPA_PLATFORMTHEME has been set to enable ${PN} usage by"
		elog "default. This will only come into effect after re-login into"
		elog "the current desktop session(s)."
		elog
		elog "Note that ${PN} should not be used with DEs that do their own"
		elog "integration (e.g. Plasma/KDE). Qt also has special handling"
		elog "for Gnome which may or may not be better."
	fi

	# not a very important warning (at most could surprise users that had it
	# installed but weren't really using it), can likely cleanup next version
	if ver_replacing -lt 0.9-r1; then
		ewarn
		ewarn "Note that ${PF} newly sets QT_QPA_PLATFORMTHEME globally"
		ewarn "by default to use ${PN} (or qt5ct if it is installed)."
	fi
}
