# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Collection of XMMS themes for Audacious"
HOMEPAGE="http://www.xmms.org"
THEME_URI="http://www.xmms.org/files/Skins"
SRC_URI="${THEME_URI}/AbsoluteE_Xmms.zip
	${THEME_URI}/Absolute_Blue-XMMS.zip
	${THEME_URI}/AdamAmp.zip
	${THEME_URI}/Apple_Platinum_Amp.zip
	${THEME_URI}/Aqua.zip
	${THEME_URI}/BlackXMMS.zip
	${THEME_URI}/BlueIce.zip
	${THEME_URI}/BlueSteel.zip
	${THEME_URI}/BlueSteel_xmms.zip
	${THEME_URI}/BrushedMetal_Xmms.zip
	${THEME_URI}/CX2.zip
	${THEME_URI}/ConceptX-Gold.zip
	${THEME_URI}/Concept_X.zip
	${THEME_URI}/Covenant.zip
	${THEME_URI}/Cyrus-XMMS.zip
	${THEME_URI}/FB_1.2.zip
	${THEME_URI}/FB_2.1.zip
	${THEME_URI}/FreeBSD.zip
	${THEME_URI}/Freshmeat_Amp.zip
	${THEME_URI}/GTK+.zip
	${THEME_URI}/Ghost-10.zip
	${THEME_URI}/HeliXMMS.zip
	${THEME_URI}/Inverse.zip
	${THEME_URI}/Marble.zip
	${THEME_URI}/NeXTAmp2-1.0pre1.zip
	${THEME_URI}/NeXTAmp2.4.zip
	${THEME_URI}/OmniAMP-1.3.zip
	${THEME_URI}/Panic.zip
	${THEME_URI}/Plume-XMMS-v1.zip
	${THEME_URI}/SuedE.zip
	${THEME_URI}/Ultrafina-pw.zip
	${THEME_URI}/Ultrafina.zip
	${THEME_URI}/Ultrafina2000.zip
	${THEME_URI}/UltrafinaSE.zip
	${THEME_URI}/UltrafinaSEM.zip
	${THEME_URI}/Vegetal_Blues.zip
	${THEME_URI}/Vegetali_1-1.zip
	${THEME_URI}/Vulcan.zip
	${THEME_URI}/Vulcan21.zip
	${THEME_URI}/WoodPanel.zip
	${THEME_URI}/X-Tra.zip
	${THEME_URI}/XMMS-AfterStep.zip
	${THEME_URI}/XMMS-Green.zip
	${THEME_URI}/XawMMS.zip
	${THEME_URI}/arctic_Xmms.zip
	${THEME_URI}/blackstar.zip
	${THEME_URI}/blueHeart-xmms-20.zip
	${THEME_URI}/blueHeart_Xmms.zip
	${THEME_URI}/bmXmms.zip
	${THEME_URI}/cart0onix.zip
	${THEME_URI}/chaos_XMMS.zip
	${THEME_URI}/cherry.zip
	${THEME_URI}/cracked.zip
	${THEME_URI}/detone_blue.zip
	${THEME_URI}/detone_green.zip
	${THEME_URI}/eMac-XMMS.zip
	${THEME_URI}/eMac_Xmms_color_schemes.zip
	${THEME_URI}/fyre.zip
	${THEME_URI}/gLaNDAmp-2.0.zip
	${THEME_URI}/minEguE-xmms-v2.zip
	${THEME_URI}/myway.zip
	${THEME_URI}/nuance-2.0.zip
	${THEME_URI}/nuance-green-2.0.zip
	${THEME_URI}/sinistar.zip
	${THEME_URI}/spiffMEDIA.zip
	${THEME_URI}/titanium.zip
	${THEME_URI}/xmms-256.zip
	${THEME_URI}/Cobalt-Obscura.tar.gz
	${THEME_URI}/ColderXMMS.tar.gz
	${THEME_URI}/Coolblue.tar.gz
	${THEME_URI}/Eclipse.tar.gz
	${THEME_URI}/LinuxDotCom.tar.gz
	${THEME_URI}/MarbleX.tar.gz
	${THEME_URI}/NoerdAmp-SE.tar.gz
	${THEME_URI}/Winamp_X_XMMS_1.01.tar.gz
	${THEME_URI}/cherry_best.tar.gz
	${THEME_URI}/fiRe.tar.gz
	${THEME_URI}/m2n.tar.gz
	${THEME_URI}/maXMMS.tar.gz
	${THEME_URI}/nixamp2.tar.gz
	${THEME_URI}/sword.tar.gz
	${THEME_URI}/xmmearth.tar.gz
	http://www.kde-look.org/content/files/7947-plastik.zip
	http://mrb.tagclan.com/files/Raj._I.O._Amp_in_2000.wsz
	http://mrb.tagclan.com/files/bluemetal.wsz
	http://mrb.tagclan.com/files/atlantis_-_meridian.wsz
	http://mrb.tagclan.com/files/ace.wsz
	http://waledawg.com/v5/files/wale_sub_contact.wsz
	http://waledawg.com/v5/files/wale_crobial_hypothesis.wsz
	http://waledawg.com/v5/files/wale_media_monks.wsz
	http://waledawg.com/v5/files/wale_atmosphere.wsz
	http://waledawg.com/v5/files/wale_RLH.wsz
	http://waledawg.com/v5/files/wale_poopshingles.wsz
	http://www.gnome-look.org/content/files/14870-Winamp5-XMMS.tar.bz2
	http://www.winamp.com/skins/download/145489?/Nucleo_AlienMind_v5.wsz"

SLOT="0"
LICENSE="freedist"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86 ~x86-fbsd"

IUSE=""

DEPEND="net-misc/wget"
RDEPEND=">=media-sound/audacious-0.1.2
	app-arch/unzip"

src_unpack() {
	local bn
	mkdir "${S}"
	cd "${S}"
	for i in ${SRC_URI} ; do
		bn=`basename $i`
		if [ -n "`echo ${bn} | grep '\.zip'`" ] ; then
			cp "${DISTDIR}"/${bn} .
		else
			if [ -n "`echo ${bn} | grep '\.wsz'`" ] ; then
				cp "${DISTDIR}"/${bn} .
			else
				unpack ${bn}
			fi
		fi
	done

	# remove nasty .xvpics directories in Fire theme
	rm -rf Fire/.xvpics

	mv 7947-plastik.zip Plastik.zip
}

src_compile() {
	einfo "Nothing to compile"
}

src_install () {
	dodir /usr/share/audacious/Skins
	cp -pR * "${D}/usr/share/audacious/Skins/"
	chmod -R o-w "${D}/usr/share/audacious/Skins/"
}
