# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

SMILEYS="critters-1.0.jisp
	icq-2002a.jisp
	ikonboard-3.1.jisp
	KMess-Cartoon-1.0.jisp
	kreativ_squareheads.jisp
	megapack-1.0.jisp
	Ninja.jisp
	patricks_faces-1.0.jisp
	shinyicons.jisp
	gadu-gadu.jisp
	emot-daw.jisp
	emot-gg.jisp
	emot-ro.jisp"

ICONSETS="amirose.7z
	crystal_roster.jisp
	crystal_aimbulb.jisp
	crystal_aim.jisp
	crystal_gadu.jisp
	crystal_icqbulb.jisp
	crystal_icq.jisp
	crystal_msnbulb.jisp
	crystal_msn.jisp
	crystal_sms.jisp
	crystal_tlen.jisp
	crystal_transport.jisp
	crystal_weatherbulb.jisp
	crystal_yahoobulb.jisp
	crystal_yahoo.jisp
	amirosebulb.jisp
	amirose_gg.jisp
	amiroseglobe.jisp
	amirose_tlen.jisp
	chromepl.jisp
	crystalgg.jisp
	dictionary_es.jisp
	email.jisp
	gadugadu.jisp
	gggangsta.jisp
	ggskazi.jisp
	ggstarfish.jisp
	hamtaro.jisp
	headlines.jisp
	hexicubes.jisp
	icqgangsta.jisp
	individual.jisp
	kb_shiny_weather.jisp
	kmess-crystal.jisp
	msn6.jisp
	nuvola-dicts.jisp
	nuvola.jisp
	psidudes.jisp
	psi_tag.jisp
	psi-daisy.7z
	shadowrss.jisp
	shadowwpk.jisp
	sms2.jisp
	speechbubbles.jisp
	squareheads.jisp
	stellar.jisp
	stellartransport.jisp
	tlen.jisp
	tlenrael.jisp
	weatheraqua.jisp
	weather.jisp
	wpkontakt2.jisp
	wpkontakt3.jisp
	ztm.jisp"

SYSTEMSETS="crystal_system.jisp
	system-psi.jisp
	nuvola-system.jisp"

VMAIN="1.0"
VCRYS="0.5"
VNETF="1.0"
HTTPIURI="http://vivid.dat.pl/psi"
SRC_URI="${HTTPIURI}/emots-main-${VMAIN}.tar.bz2
	${HTTPIURI}/gadu-gadu-1.0.tar.bz2
	${HTTPIURI}/emots-crystal-${VCRYS}.tar.bz2
	${HTTPIURI}/emots-netflint-${VNETF}.tar.bz2"

DESCRIPTION="Iconsets for Psi, a Qt4 Jabber Client"
HOMEPAGE="http://psi-im.org/ http://jisp.netflint.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc x86 ~x86-fbsd"
IUSE=""
DEPEND=">=net-im/psi-0.9.2
	!!net-im/psi[extras]"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"

	mkdir roster
	for FILE in ${ICONSETS}; do
		if [ -e emots/${FILE} ]; then
			mv emots/${FILE} roster
		fi
	done;

	mkdir emoticons
	for FILE in ${SMILEYS}; do
		if [ -e emots/${FILE} ]; then
			mv emots/${FILE} emoticons
		fi
	done;

	mkdir system
	for FILE in ${SYSTEMSETS}; do
		if [ -e emots/${FILE} ]; then
			mv emots/${FILE} system
		fi
	done;
}

src_install() {
	dodir /usr/share/psi/iconsets
	mv {emoticons,system,roster} "${D}/usr/share/psi/iconsets/"
}
