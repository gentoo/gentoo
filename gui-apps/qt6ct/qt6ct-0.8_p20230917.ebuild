# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt6 Configuration Tool (for DE/WM without Qt integration)"
HOMEPAGE="https://github.com/trialuser02/qt6ct/"
#SRC_URI="https://github.com/trialuser02/qt6ct/releases/download/${PV}/${P}.tar.xz"

# temporary snapshot for https://github.com/trialuser02/qt6ct/issues/32
QT6CT_HASH=f083799f1495dabaeeb482274ee90c73a0a78a43
SRC_URI="
	https://github.com/trialuser02/qt6ct/archive/${QT6CT_HASH}.tar.gz
		-> ${P}.tar.gz
"
S=${WORKDIR}/${PN}-${QT6CT_HASH}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

# uses Qt private APIs wrt :=
DEPEND="dev-qt/qtbase:6=[gui,widgets]"
RDEPEND="
	${DEPEND}
	dev-qt/qtsvg:6
"
BDEPEND="
	dev-qt/qtbase:6
	dev-qt/qttools:6[linguist]
"

pkg_postinst() {
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "Note need to export QT_QPA_PLATFORMTHEME=qt6ct in the used environment"
		elog "for theming to take effect (not done automatically, may want to set in"
		elog "the HOME's shell initialization scripts, or use /etc/env.d followed by"
		elog "running env-update then re-login)."
		elog
		elog "If also using x11-misc/qt5ct, =qt5ct is alternatively recognized so it"
		elog "can be activated for both Qt5 and Qt6 at once."
	fi
}
