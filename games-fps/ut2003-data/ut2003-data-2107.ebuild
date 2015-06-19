# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2003-data/ut2003-data-2107.ebuild,v 1.12 2012/02/05 06:11:45 vapier Exp $

inherit eutils unpacker cdrom games

DESCRIPTION="Unreal Tournament 2003 - Sequel to the 1999 Game of the Year multi-player first-person shooter"
HOMEPAGE="http://www.unrealtournament2003.com/"
SRC_URI="http://download.factoryunreal.com/mirror/UT2003CrashFix.zip"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="strip"

RDEPEND=""
DEPEND="app-arch/unzip
	games-util/uz2unpack"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/ut2003
Ddir=${D}/${dir}

pkg_setup() {
	games_pkg_setup
	ewarn "The installed game takes about 2.7GB of space!"
}

src_unpack() {
	cdrom_get_cds System/Packages.md5 StaticMeshes/AWHardware.usx.uz2 \
		Extras/MayaPLE/Maya4PersonalLearningEditionEpic.exe
	unzip "${DISTDIR}"/UT2003CrashFix.zip \
		|| die "unpacking crash-fix"
}

src_install() {
	insinto "${dir}"
	# Disk 1
	einfo "Copying files from Disk 1..."
	doins -r "${CDROM_ROOT}"/{Animations,ForceFeedback,KarmaData,Maps,Sounds,Textures,Web} || die "copying files"
	insinto "${dir}"/System
	doins -r "${CDROM_ROOT}"/System/{editorres,*.{bmp,dat,det,est,frt,ini,int,itt,md5,u,upl,url}} || die "copying files"
	insinto "${dir}"/Benchmark/Stuff
	doins -r "${CDROM_ROOT}"/Benchmark/Stuff/* || die "copying benchmark files"
	cdrom_load_next_cd

	# Disk 2
	insinto "${dir}"
	einfo "Copying files from Disk 2..."
	doins -r "${CDROM_ROOT}"/{Music,Sounds,StaticMeshes,Textures} \
		|| die "copying files"
	cdrom_load_next_cd

	# Disk 3
	einfo "Copying files from Disk 3..."
	doins -r "${CDROM_ROOT}"/Sounds || die "copying files"

	# TODO: move this to src_unpack, where it belongs
	unpack_makeself "${CDROM_ROOT}"/linux_installer.sh \
		|| die "unpacking linux installer"
	tar xf "${S}"/ut2003lnxbins.tar \
		|| die "unpacking original binaries/libraries"

	# create empty files in Benchmark
	for j in {CSVs,Logs,Results} ; do
		mkdir -p "${Ddir}"/Benchmark/${j} || die "creating folders"
		touch "${Ddir}"/Benchmark/${j}/DO_NOT_DELETE.ME || die "creating files"
	done

	# Cleaning up our installation
	rm "${Ddir}"/System/{Build,Def{ault,User},Manifest,UT2003,User}.ini \
		|| die "deleting ini files"
	rm -f "${Ddir}"/System/{Core,Engine,Setup,UnrealGame,Window,XGame,XInterface,XWeapons}.{det,est,frt,int,itt,u} || die "deleting files that have been patched"
	rm -rf "${Ddir}"/Web/ServerAdmin || die "deleting server admin web pages"
	rm -f "${Ddir}"/System/{Editor,Fire,IpDrv,UnrealEd,Vehicles,XEffects,XPickups,XWebAdmin}.u || die "removing files that will be coming from the patch"
	rm -f "${Ddir}"/System/{UWeb,XAdmin}.{int,u} || die "removing patched files"
	rm -f "${Ddir}"/System/GamePlay.{det,itt,u} || die "patch files removal"
	rm -f "${Ddir}"/System/XMaps.{det,est} "${Ddir}"/System/Xweapons.itt \
		|| die "removing unused files"
	rm -f "${Ddir}"/System/Manifest.int "${Ddir}"/System/Packages.md5 \
		|| die "cleanup"

	# install extra help files
	insinto "${dir}"/Help
	doins "${S}"/Help/Unreal.bmp

	# install Default and DefUser ini files
	insinto "${dir}"/System
	doins "${S}"/System/Def{ault,User}.ini

	# install eula
	insinto "${dir}"
	doins "${S}"/eula/License.int

	# copying extra/updater
	doins -r "${S}"/{extras,updater} || die "copying extras/updater"
	rm -f "${Ddir}"/updater/update || die "removing update"

	# copy libraries
	exeinto "${dir}"/System
	doexe "${S}"/System/libSDL-1.2.so.0 \
		|| die "copying libSDL"

	# uncompressing files
	einfo "Uncompressing files... this may take a while..."
	for j in {Animations,Maps,Sounds,StaticMeshes,Textures} ; do
		games_ut_unpack "${Ddir}"/${j} || die "uncompressing files"
	done

	# installing documentation/icon
	dodoc "${S}"/README.linux || die "dodoc README.linux"
	newicon "${S}"/Unreal.xpm ut2003.xpm || die "copying icon"
	doins "${S}"/README.linux "${S}"/Unreal.xpm || die "copying readme/icon"
	# copy ut2003/ucc
	exeinto "${dir}"
	doexe "${S}"/bin/ut2003 "${S}"/ucc || die "copying ut2003/ucc"

	# Here we apply DrSiN's crash patch
	cp "${S}"/CrashFix/System/crashfix.u "${Ddir}"/System

	ed "${Ddir}"/System/Default.ini >/dev/null 2>&1 <<EOT
$
?Engine.GameInfo?
a
AccessControlClass=crashfix.iaccesscontrolini
.
w
q
EOT

	# Here we apply fix for bug #54726
	dosed "s:UplinkToGamespy=True:UplinkToGamespy=False:" \
		"${dir}"/System/Default.ini

	# now, since these files are coming off a cd, the times/sizes/md5sums wont
	# be different ... that means portage will try to unmerge some files (!)
	# we run touch on ${D} so as to make sure portage doesnt do any such thing
	find "${Ddir}" -exec touch '{}' \;

	prepgamesdirs
}
