# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

IUSE=""
if [[ ${PV} == *9999* ]]; then
	inherit mercurial
	EHG_REPO_URI="https://bitbucket.org/BattleClinic/${PN}"
	KEYWORDS=""
	SRC_URI=""
	MY_S="${WORKDIR}/${P}/gtkevemon"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="http://gtkevemon.battleclinic.com/releases/${P}-source.tar.gz"
fi

DESCRIPTION="A standalone skill monitoring application for EVE Online"
HOMEPAGE="http://gtkevemon.battleclinic.com"

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	dev-cpp/gtkmm:2.4
	dev-libs/libxml2
"
DEPEND="${DEPEND}
	virtual/pkgconfig
"

src_unpack()
{
	if [[ ${PV} == *9999* ]]; then
		mercurial_src_unpack
		S=${MY_S}
	else
		default
	fi
}

src_prepare() {
	sed -e 's:Categories=Game;$:Categories=Game;RolePlaying;GTK;:' \
		-i icon/${PN}.desktop || die "sed failed"
}

src_install() {
	# fixed QA notice
	sed -i "/^Encoding/d" icon/${PN}.desktop
	dobin src/${PN}
	doicon icon/${PN}.svg
	domenu icon/${PN}.desktop
	dodoc CHANGES README TODO
}
