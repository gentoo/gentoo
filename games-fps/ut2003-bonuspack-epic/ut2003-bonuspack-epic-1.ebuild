# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit games

IUSE=""
DESCRIPTION="Epic Bonus Pack for UT2003"
HOMEPAGE="http://www.unrealtournament2003.com/"
SRC_URI="UT2003-epicbonuspackone.exe"

LICENSE="ut2003"
SLOT="1"
KEYWORDS="x86"
RESTRICT="fetch strip"

DEPEND="app-arch/unzip"
RDEPEND="games-fps/ut2003"

S=${WORKDIR}/UT2003-BonusPack

dir=${GAMES_PREFIX_OPT}/ut2003
Ddir=${D}/${dir}

pkg_nofetch() {
	einfo "Please download ${A} and put it into ${DISTDIR}"
	einfo "http://files.filefront.com/ut2003+epicbonuspackoneexe/;826445;/fileinfo.html"
}

src_unpack() {
	unzip -qq "${DISTDIR}"/${A} || die "unpacking"
	# This is done since the files are the same
	rm -f "${S}"/Textures/LastManStanding.utx
}

src_install() {
	insinto "${dir}"/Help
	newins "${S}"/Help/BonusPackReadme.txt EpicBonusPack.README || die "README"

	exeinto "${dir}"
	doexe "${FILESDIR}"/epic-installer
	dodir "${dir}"/System

	cp -r "${S}"/{Maps,Sounds,StaticMeshes,Textures} "${Ddir}" \
		|| die "Copying Maps/Sounds/Textures"
	cp "${S}"/System/{*.{det,est,frt,int,itt,kot,tmt,u},User.ini} \
		"${Ddir}"/System || die "Copying System files"
	cp -v "${S}"/System/Manifest.ini "${Ddir}"/System/Manifest.ini.epic \
		|| die "Copying Manifest"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "You will need to run:"
	elog "emerge --config =${CATEGORY}/${PF}"
	elog "to make the necessary changes to the system .ini files."
	elog
	elog "Each user whom has already played the game will need to run:"
	elog " ${dir}/epic-installer"
	echo
	elog "to update their configuration files in their home directory."
	echo
}

pkg_config() {
	cd ${dir}/System
	cp Manifest.ini Manifest.ini.pre-epic
	cp ${dir}/System/Manifest.ini.epic Manifest.ini

	cp Default.ini Default.ini.pre-epic
	cat >> Default.ini <<EOT

[Xinterface.Tab_AudioSettings]
BonusPackInfo[1]=(PackageName="AnnouncerEvil.uax",Description="Evil")
BonusPackInfo[2]=(PackageName="AnnouncerFemale.uax",Description="Female")
BonusPackInfo[3]=(PackageName="AnnouncerSexy.uax",Description="Aroused")

EOT

	ed Default.ini >/dev/null 2>&1 <<EOT
/\[xInterface.ExtendedConsole\]
a
MusicManagerClassName=OGGPlayer.UT2OGGMenu
.
w
q
EOT

	ed Default.ini >/dev/null 2>&1 <<EOT
$
?EditPackages?
a
EditPackages=BonusPack
EditPackages=SkaarjPack
EditPackages=SkaarjPack_rc
.
w
q
EOT

	ed Default.ini >/dev/null 2>&1 <<EOT
$
?ServerPackages?
a
ServerPackages=BonusPack
ServerPackages=SkaarjPack
ServerPackages=SkaarjPack_rc
.
w
q
EOT

	cp DefUser.ini DefUser.ini.pre-epic
	sed -i 's/^F11=.*$/F11=MusicMenu/g' DefUser.ini
	chown games:games ${dir}/System/*.ini
}
