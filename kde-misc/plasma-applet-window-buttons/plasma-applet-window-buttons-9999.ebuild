# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/plasma-/}"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 ecm
	EGIT_REPO_URI="https://github.com/psifidotos/${MY_PN}"
else
	inherit ecm
	SRC_URI="https://github.com/psifidotos/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="Plasma 5 applet in order to show window buttons in your panels"
HOMEPAGE="https://github.com/psifidotos/applet-window-buttons"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	kde-frameworks/kconfig:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/ki18n:5
	kde-frameworks/kservice:5
	kde-frameworks/plasma:5
	kde-plasma/kdecoration:5
"
RDEPEND="${DEPEND}"
