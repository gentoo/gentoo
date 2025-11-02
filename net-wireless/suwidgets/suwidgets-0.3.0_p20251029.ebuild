# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit qmake-utils

DESCRIPTION="graphical library containing all SigDigger's custom widgets"
HOMEPAGE="https://github.com/BatchDrake/SuWidgets"
SRC_URI="https://dev.gentoo.org/~tomjbe/distfiles/${P}.tgz"

S="${WORKDIR}/SuWidgets-${PV}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtbase:6[gui,opengl,widgets]
	media-libs/libglvnd
	>=net-wireless/sigutils-0.3.0_p20251029
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i '/^#include <QPainter>/i #include <QPainterPath>' Waveform.cpp Waterfall.cpp	\
		Transition.cpp SymView.cpp QVerticalLabel.cpp LCD.cpp Histogram.cpp \
		Constellation.cpp ColorChooserButton.cpp

	default
}

src_configure() {
	eqmake6 SuWidgetsLib.pro
}

src_install() {
	INSTALL_ROOT="${ED}" emake install
}
