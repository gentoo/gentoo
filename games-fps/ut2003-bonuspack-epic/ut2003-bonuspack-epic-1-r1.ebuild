# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Epic Bonus Pack for UT2003"
HOMEPAGE="https://www.moddb.com/games/unreal-tournament-2003"
SRC_URI="http://ftp.student.utwente.nl/pub/games/UT2003/BonusPack/UT2003-epicbonuspackone.exe"
S="${WORKDIR}"/UT2003-BonusPack

LICENSE="ut2003"
SLOT="1"
KEYWORDS="~x86"
RESTRICT="bindist mirror strip"

RDEPEND="
	acct-group/gamestat
	games-fps/ut2003
"
BDEPEND="app-arch/unzip"

dir=opt/ut2003
Ddir="${ED}"/${dir}

src_unpack() {
	unzip -qq "${DISTDIR}"/${A} || die

	# This is done since the files are the same
	rm -f "${S}"/Textures/LastManStanding.utx || die
}

src_install() {
	insinto "${dir}"/Help
	newins "${S}"/Help/BonusPackReadme.txt EpicBonusPack.README

	exeinto "${dir}"
	doexe "${FILESDIR}"/epic-installer
	dodir "${dir}"/System

	cp -r "${S}"/{Maps,Sounds,StaticMeshes,Textures} "${Ddir}" || die
	cp "${S}"/System/{*.{det,est,frt,int,itt,kot,tmt,u},User.ini} "${Ddir}"/System || die
	cp -v "${S}"/System/Manifest.ini "${Ddir}"/System/Manifest.ini.epic || die
}

pkg_postinst() {
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
	cd ${dir}/System || die
	cp Manifest.ini Manifest.ini.pre-epic || die
	cp ${dir}/System/Manifest.ini.epic Manifest.ini || die

	cp Default.ini Default.ini.pre-epic || die
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

	cp DefUser.ini DefUser.ini.pre-epic || die
	sed -i 's/^F11=.*$/F11=MusicMenu/g' DefUser.ini || die
	chown :gamestat "${dir}"/System/*.ini || die
}
