# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit qmake-utils

DESCRIPTION="graphical library containing all SigDigger's custom widgets"
HOMEPAGE="https://github.com/BatchDrake/SuWidgets"
SRC_URI="https://github.com/BatchDrake/SuWidgets/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/SuWidgets-${PV}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	media-libs/libglvnd
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i '/^#include <QPainter>/i #include <QPainterPath>' Waveform.cpp Waterfall.cpp	\
		Transition.cpp SymView.cpp QVerticalLabel.cpp LCD.cpp Histogram.cpp \
		Constellation.cpp ColorChooserButton.cpp

	default
}

src_configure() {
	eqmake5 SuWidgetsLib.pro
}

src_install() {
	INSTALL_ROOT="${ED}" emake install
}
