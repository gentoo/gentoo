# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gkrellm-themes/gkrellm-themes-0.1.ebuild,v 1.18 2015/05/14 16:29:05 mr_bones_ Exp $

EAPI=5
DESCRIPTION="A pack of ~200 themes for GKrellM"
HOMEPAGE="http://www.muhri.net/gkrellm"
THEME_URI="http://www.muhri.net/gkrellm"
SRC_URI="${THEME_URI}/3051.tar.gz
	${THEME_URI}/4D_Ladies.tar.gz
	${THEME_URI}/AbToenAlloy-green.tar.gz
	${THEME_URI}/Absolute_E.tar.gz
	${THEME_URI}/Acqua-Graphite.gkrellm.tar.gz
	${THEME_URI}/Acqua.gkrellm.tar.gz
	${THEME_URI}/Aqua.gkrellm.tgz
	${THEME_URI}/AquaLuna.tar.gz
	${THEME_URI}/Azteker2k.gkrellm.tar.gz
	${THEME_URI}/BBX_mercury.tar.gz
	${THEME_URI}/Beta.gkrellm.tar.gz
	${THEME_URI}/Birth-gkrellm.tar.gz
	${THEME_URI}/BloeSteel.tar.gz
	${THEME_URI}/BloeStolen.tar.gz
	${THEME_URI}/BlueCyrus.tar.gz
	${THEME_URI}/BlueKrooks.tgz
	${THEME_URI}/BlueMask-gkrellm.tar.gz
	${THEME_URI}/BlueStorm.tar.gz
	${THEME_URI}/BlueX4-gkrellm.tar.gz
	${THEME_URI}/Brass.tar.gz
	${THEME_URI}/BrassAlloy-gkrellm.tar.gz
	${THEME_URI}/BrushedMetal-gkrellm.tar.gz
	${THEME_URI}/CaiusWM.tar.gz
	${THEME_URI}/Cheese.tar.gz
	${THEME_URI}/ClockworkCobalt.tar.gz
	${THEME_URI}/Cobalt.tar.gz
	${THEME_URI}/CoplandOS.gkrellm.tar.gz
	${THEME_URI}/Crux_chaos.tar.gz
	${THEME_URI}/Cyroid.tar.gz
	${THEME_URI}/D.A.E.gkrellm.tar.gz
	${THEME_URI}/DarkAlloy.tar.gz
	${THEME_URI}/DreamWorks.tar.gz
	${THEME_URI}/Dune-GKrellM.tar.gz
	${THEME_URI}/E-Tech_GkrellM.tar.gz
	${THEME_URI}/E-Tech_XSlate_GKrellM.tar.gz
	${THEME_URI}/E17.gkrellm.tar.gz
	${THEME_URI}/EJ.tar.gz
	${THEME_URI}/EMOZ.gkrellm.tar.gz
	${THEME_URI}/Eazel.gkrellm.tar.gz
	${THEME_URI}/Evilution.tar.gz
	${THEME_URI}/Evolution.tar.gz
	${THEME_URI}/GTK.tar.gz
	${THEME_URI}/GTKStep-gkrellm.tar.gz
	${THEME_URI}/Ganymede_gkrellm.tar.gz
	${THEME_URI}/Glass-2.tar.gz
	${THEME_URI}/Glass-3.tar.gz
	${THEME_URI}/Glass.gkrellm.tar.gz
	${THEME_URI}/GothamCity.tar.gz
	${THEME_URI}/H2O.tar.gz
	${THEME_URI}/HeliX-Sweetpill.gkrellm.tar.gz
	${THEME_URI}/Hifi.tar.gz
	${THEME_URI}/HifiII.tar.gz
	${THEME_URI}/IReX.tar.gz
	${THEME_URI}/IReX_gkrellm.tar.gz
	${THEME_URI}/Illumination.tar.gz
	${THEME_URI}/JMswing.tar.gz
	${THEME_URI}/Jester.tar.gz
	${THEME_URI}/Jewel_gkrellm.tar.gz
	${THEME_URI}/Jose_Goes_To_Town.tar.gz
	${THEME_URI}/Jose_Helix.tar.gz
	${THEME_URI}/K5-FVWM.tar.gz
	${THEME_URI}/Led.tar.gz
	${THEME_URI}/Marble.tar.gz
	${THEME_URI}/Marble2.tar.gz
	${THEME_URI}/Matrix_Green.gkrellm.tar.gz
	${THEME_URI}/Maw-gkrellm.tar.gz
	${THEME_URI}/MeLike-gkrellm.tar.gz
	${THEME_URI}/Modern.tar.gz
	${THEME_URI}/ModernII.gkrellm.tar.gz
	${THEME_URI}/Monk.tar.gz
	${THEME_URI}/MonkeyLovers.tar.gz
	${THEME_URI}/Mozilla-modern.tar.gz
	${THEME_URI}/Nebulon-GKrellM.tar.gz
	${THEME_URI}/New-Found.gkrellm.tar.gz
	${THEME_URI}/NoBevel-gkrellm.tar.gz
	${THEME_URI}/OSX.tar.gz
	${THEME_URI}/Operational.tar.gz
	${THEME_URI}/Oregano.tar.gz
	${THEME_URI}/Photon.tar.gz
	${THEME_URI}/Plastique.tar.gz
	${THEME_URI}/PurpHaze.tar.gz
	${THEME_URI}/ReGet-E.tar.gz
	${THEME_URI}/Runes-GKrellM.tar.gz
	${THEME_URI}/SQR01.tar.gz
	${THEME_URI}/STPShiny-gkrellm.tar.gz
	${THEME_URI}/SentiEnce.gkrellm.tar.gz
	${THEME_URI}/Sham.tar.gz
	${THEME_URI}/ShinyAll2.tar.gz
	${THEME_URI}/ShinyMetal-Blue.tar.gz
	${THEME_URI}/ShinyMetal.tar.gz
	${THEME_URI}/ShinyMetal2.tar.gz
	${THEME_URI}/Skirellm.tar.gz
	${THEME_URI}/Snowy.gkrellm.tar.gz
	${THEME_URI}/SolarE-2.gkrellm.tar.gz
	${THEME_URI}/SolarE.gkrellm.tar.gz
	${THEME_URI}/Steel.tar.gz
	${THEME_URI}/SteelX.tar.gz
	${THEME_URI}/SuedE.tar.gz
	${THEME_URI}/TaoMetal.tar.gz
	${THEME_URI}/Thin-SkE.gkrellm.tar.gz
	${THEME_URI}/TruBlu2.tar.gz
	${THEME_URI}/UltraFuture_gkrellm.tar.gz
	${THEME_URI}/Veg9000.tar.gz
	${THEME_URI}/Viridis_gkrellm.tar.gz
	${THEME_URI}/Win-Whistle.gkrellm.tar.gz
	${THEME_URI}/WireFrame.tgz
	${THEME_URI}/WireFrameII.tar.gz
	${THEME_URI}/XenoSilvereX.tar.gz
	${THEME_URI}/Xenophilia-gkrellm.tar.gz
	${THEME_URI}/Yellow.tar.gz
	${THEME_URI}/Yeti.tar.gz
	${THEME_URI}/ZixSaw-gkrellm.tar.gz
	${THEME_URI}/ZixSaw2-gkrellm.tar.gz
	${THEME_URI}/aCOW.tar.gz
	${THEME_URI}/adept.tar.gz
	${THEME_URI}/aliens.tar.gz
	${THEME_URI}/aliens.tgz
	${THEME_URI}/amber2.tar.gz
	${THEME_URI}/antarctic.gkrellm.tar.gz
	${THEME_URI}/arctic-2.gkrellm.tar.gz
	${THEME_URI}/arctic-3.gkrellm.tar.gz
	${THEME_URI}/arctic-Bordered-2.tar.gz
	${THEME_URI}/arctic-Bordered.tar.gz
	${THEME_URI}/arctic.tar.gz
	${THEME_URI}/bevelfree_gkrellm.tar.gz
	${THEME_URI}/bk10.gkrellm.tar.gz
	${THEME_URI}/black.tar.gz
	${THEME_URI}/blue.tar.gz
	${THEME_URI}/blueHeart_gkrellm.tar.gz
	${THEME_URI}/blueHeart_v1.2_gkrellm.tar.gz
	${THEME_URI}/bluesteel.tar.gz
	${THEME_URI}/brgnd-E.gkrellm.tar.gz
	${THEME_URI}/brnGradient.tar.gz
	${THEME_URI}/brushed.tar.gz
	${THEME_URI}/brushede16.tar.gz
	${THEME_URI}/brushedmetalnew.tar.gz
	${THEME_URI}/c2h8.gkrellm.tar.gz
	${THEME_URI}/chaos.gkrellm.tar.gz
	${THEME_URI}/clain.tar.gz
	${THEME_URI}/coffee-cream.tar.gz
	${THEME_URI}/concrete.tar.gz
	${THEME_URI}/copper-gkrellm.tar.gz
	${THEME_URI}/cousin_2_c2h8.tar.gz
	${THEME_URI}/crux.tar.gz
	${THEME_URI}/cyrus.gkrellm.tar.gz
	${THEME_URI}/cyrus.tar.gz
	${THEME_URI}/cyrus2.tar.gz
	${THEME_URI}/dark-smokey.tar.gz
	${THEME_URI}/dirtchamber.gkrellm.tar.gz
	${THEME_URI}/eFVWM.tar.gz
	${THEME_URI}/eLap.tar.gz
	${THEME_URI}/eMac.tar.gz
	${THEME_URI}/eSlate_gkrellm.tar.gz
	${THEME_URI}/egan-gkrellm.tar.gz
	${THEME_URI}/get-E-blue.gkrellm.tar.gz
	${THEME_URI}/getE.gkrellm.tar.gz
	${THEME_URI}/getE2.gkrellm.tar.gz
	${THEME_URI}/gklcars.tar.gz
	${THEME_URI}/gkrellm-nlog.tar.gz
	${THEME_URI}/gkrellm-qn-x11.tar.gz
	${THEME_URI}/glass.gkrellm.tar.gz
	${THEME_URI}/greenHeart_gkrellm.tar.gz
	${THEME_URI}/greyNeOn.gkrellm.tar.gz
	${THEME_URI}/indiglow_blue-gkrellm.tar.gz
	${THEME_URI}/invisible.tar.gz
	${THEME_URI}/keramik.tar.gz
	${THEME_URI}/krooks.tar.gz
	${THEME_URI}/m0kH4.tar.gz
	${THEME_URI}/master.tar.gz
	${THEME_URI}/matrix_feeling-0.1.tar.gz
	${THEME_URI}/milk.tar.gz
	${THEME_URI}/minE-Gkrellm.tar.gz
	${THEME_URI}/minEguE_lite.tar.gz
	${THEME_URI}/minegue-beta.tar.gz
	${THEME_URI}/myway.tar.gz
	${THEME_URI}/nIx_gkrellm.tar.gz
	${THEME_URI}/niumx.tar.gz
	${THEME_URI}/null-gkrellm.tar.gz
	${THEME_URI}/plain-black.tar.gz
	${THEME_URI}/platinum.tar.gz
	${THEME_URI}/prime23.tar.gz
	${THEME_URI}/propaganda2a.tar.gz
	${THEME_URI}/propaganda2b.tar.gz
	${THEME_URI}/r9x_gkrellm.tar.gz
	${THEME_URI}/red.tar.gz
	${THEME_URI}/sandymidnight.tar.gz
	${THEME_URI}/spiff.tar.gz
	${THEME_URI}/spiffE.tar.gz
	${THEME_URI}/stirling.gkrellm.tar.gz
	${THEME_URI}/sunset.gkrellm.tar.gz
	${THEME_URI}/thinsys.tar.gz
	${THEME_URI}/tiny.gkrellm.tar.gz
	${THEME_URI}/trublu.tar.gz
	${THEME_URI}/twilite.tar.gz
	${THEME_URI}/x17.tar.gz
	${THEME_URI}/yummiyogurt.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 sparc x86"
IUSE=""
RESTRICT="strip"

DEPEND=""
RDEPEND=">=app-admin/gkrellm-2.1"

src_unpack() {
	mkdir "${S}"
	cd "${S}"
	for theme in ${SRC_URI} ; do
		unpack $(basename $theme)
	done
}

src_compile() { :; }

src_install() {
	dodir /usr/share/gkrellm2/themes/
	keepdir /usr/share/gkrellm2/themes/
	cd "${S}"
	ewarn "Please ignore any errors that may appear!"
	chmod -R g-sw+rx *
	chmod -R o-sw+rx *
	chmod -R u-s+rwx *
	cp -pR * "${D}"/usr/share/gkrellm2/themes/
}
