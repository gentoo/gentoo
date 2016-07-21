# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PLOCALES="ca cs de es fr it ru"

inherit cmake-utils l10n

MY_P=${PN}4-${PV/_/-}

DESCRIPTION="A Qt frontend to nmap"
HOMEPAGE="http://www.nmapsi4.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
"
DEPEND="${CDEPEND}
	dev-qt/linguist-tools:5
"
RDEPEND="${CDEPEND}
	net-analyzer/nmap
	net-dns/bind-tools
"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS HACKING README.md TODO Translation )

nmapsi_disable_locale() {
	sed -i -e "/ts\/${PN}4_${1}\.ts/d" src/CMakeLists.txt || die
}

src_prepare() {
	l10n_for_each_disabled_locale_do nmapsi_disable_locale
	cmake-utils_src_prepare
}
