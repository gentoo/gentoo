# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO: Break themes up by author and into sub-dirs named after
# the author

DESCRIPTION="Collection of Window Maker themes"
HOMEPAGE="http://www.windowmaker.org/"

THEME_URI="http://gentoo.asleep.net/windowmaker-themes/"
SRC_URI="${THEME_URI}3white.tar.gz
	${THEME_URI}AM.tar.gz
	${THEME_URI}Alpha.tar.gz
	${THEME_URI}Amiga.tar.gz
	${THEME_URI}Anguish.tar.gz
	${THEME_URI}ArtworkEye.tar.gz
	${THEME_URI}Aurora.tar.gz
	${THEME_URI}BBChaos.tar.gz
	${THEME_URI}BackandBlue.tar.gz
	${THEME_URI}BadtzDark.tar.gz
	${THEME_URI}BadtzLight.tar.gz
	${THEME_URI}Bathroom.tar.gz
	${THEME_URI}Brijach.tar.gz
	${THEME_URI}ChiasaAonuma.tar.gz
	${THEME_URI}Cold.tar.gz
	${THEME_URI}Crave.tar.gz
	${THEME_URI}Cyrus-Hds.tar.gz
	${THEME_URI}DarwinsiMac.tar.gz
	${THEME_URI}DigitalGirls.tar.gz
	${THEME_URI}Edify.tar.gz
	${THEME_URI}Electron.tar.gz
	${THEME_URI}Estranged.tar.gz
	${THEME_URI}FunkMapping.tar.gz
	${THEME_URI}G4Blue.tar.gz
	${THEME_URI}G4Grey.tar.gz
	${THEME_URI}G4_Blue.tar.gz
	${THEME_URI}G4_Grey.tar.gz
	${THEME_URI}GraveSite.tar.gz
	${THEME_URI}ImacgirlGrape.tar.gz
	${THEME_URI}Intrigue.tar.gz
	${THEME_URI}Latest.tar.gz
	${THEME_URI}Lichen.tar.gz
	${THEME_URI}Midnight.tar.gz
	${THEME_URI}MidoriLinux.tar.gz
	${THEME_URI}Monday.tar.gz
	${THEME_URI}RainGutter.tar.gz
	${THEME_URI}Rain_Gutter.tar.gz
	${THEME_URI}RedDot.tar.gz
	${THEME_URI}Sunken.tar.gz
	${THEME_URI}TauCetiCentral.tar.gz
	${THEME_URI}Tiger-T.tar.gz
	${THEME_URI}WMFlare.tar.gz
	${THEME_URI}WMFrost.tar.gz
	${THEME_URI}WMSecksy.tar.gz
	${THEME_URI}WO.tar.gz
	${THEME_URI}Weep.tar.gz
	${THEME_URI}YesterdayIdied.tar.gz
	${THEME_URI}arrownomoreconcepts-default-0.2.tar.gz
	${THEME_URI}artworkeye.tar.gz
	${THEME_URI}asleep.net-1.tar.gz
	${THEME_URI}asleep.net-2.tar.gz
	${THEME_URI}ataglance-default-0.2.tar.gz
	${THEME_URI}bathroom.tar.gz
	${THEME_URI}bluecobra-default.tar.gz
	${THEME_URI}blueflowerdark-default-0.2.tar.gz
	${THEME_URI}bluemotion-default.tar.gz
	${THEME_URI}darwin.tar.gz
	${THEME_URI}el_roacho-default-0.2.tar.gz
	${THEME_URI}fauna-default.tar.gz
	${THEME_URI}funkmapping.tar.gz
	${THEME_URI}giraffe-default-0.2.tar.gz
	${THEME_URI}grassaftertherain-default-0.2.tar.gz
	${THEME_URI}heavyDV.tar.gz
	${THEME_URI}imacgirlgrape.tar.gz
	${THEME_URI}ladybird-default-0.2.tar.gz
	${THEME_URI}lordsofacid.tar.gz
	${THEME_URI}midori.tar.gz
	${THEME_URI}reddot.tar.gz
	${THEME_URI}redslip.tar.gz
	${THEME_URI}thefuzzyhornet-default.tar.gz
	${THEME_URI}where-default-0.2.tar.gz
	${THEME_URI}wmfrost.tar.gz
	${THEME_URI}yondo.tar.gz"

# Some people have complained about nearly getting in trouble while at work
#   because some of the themes are either pornographic or even artistic, but
#   "for adults only"; This is a quick hack to no install those themes
#   without the "offensive" use flag on.
MY_OFFENSIVE="3white.tar.gz
	Anguish.tar.gz"

IUSE="offensive"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 hppa ppc sparc x86 ~amd64-fbsd"

DEPEND=""
RDEPEND="x11-wm/windowmaker"

src_unpack() {
	mkdir "${S}"
	cd "${S}"
	for i in ${SRC_URI} ; do
		bn=`basename $i`
		if ! use offensive ; then
			for j in ${MY_OFFENSIVE} ; do
				if [ "${bn}" == "${j}" ]; then
					einfo "Skipping possibly offensive theme: ${bn}"
					continue 2
				fi
			done
		fi
		unpack ${bn}
	done
}

src_install() {
	dodir /usr/share/WindowMaker/Themes
	cp -pR * "${D}"/usr/share/WindowMaker/Themes/
	# TODO: Need to clean this up at some point ...
	#mv ${D}/usr/share/WindowMaker/Themes/Themes/* ${D}/usr/share/WindowMaker/Themes
	#rm -Rf ${D}/usr/share/WindowMaker/Themes/Themes
	chown -R root:0 "${D}"/usr/share/WindowMaker/Themes/
	chmod -R o-w "${D}"/usr/share/WindowMaker/Themes/
}

pkg_postinst() {
	einfo "The Window Maker themes downloaded are by the following artists:"
	einfo "A.Sleep - http://www.asleep.net/"
	einfo "Largo   - http://largo.windowmaker.org/"
	einfo "Hadess  - http://www.hadess.net/"
	einfo "jenspen - http://themes.freshmeat.net/~jenspen/"
}
