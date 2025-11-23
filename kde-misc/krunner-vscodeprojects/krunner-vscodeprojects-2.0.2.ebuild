# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.7.0
QTMIN=6.7.2

inherit ecm

DESCRIPTION="Open VSCode Project Manager projects from Krunner"
HOMEPAGE="https://github.com/alex1701c/krunner-vscodeprojects"
SRC_URI="https://github.com/alex1701c/krunner-vscodeprojects/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
	kde-frameworks/krunner:6
	kde-frameworks/kconfig:6
	kde-frameworks/ki18n:6
"
RDEPEND="${DEPEND}
	|| ( app-editors/vscode app-editors/vscodium )
"
