# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop cdrom unpacker

DESCRIPTION="Unreal Tournament 2003 - Sequel to the 1999 multi-player first-person shooter"
HOMEPAGE="http://www.unrealtournament2003.com/"
SRC_URI="https://dev.gentoo.org/~chewi/distfiles/UT2003CrashFix.zip" # MIT licensed (bug #754360)
S="${WORKDIR}"

LICENSE="ut2003 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist mirror strip"

BDEPEND="
	app-arch/unzip
	games-util/uz2unpack
"

dir=opt/ut2003
Ddir="${ED}"/${dir}

pkg_setup() {
	ewarn "The installed game takes about 2.7GB of space!"
}

src_unpack() {
	cdrom_get_cds System/Packages.md5 StaticMeshes/AWHardware.usx.uz2 \
		Extras/MayaPLE/Maya4PersonalLearningEditionEpic.exe
	unzip "${DISTDIR}"/UT2003CrashFix.zip || die
}

src_install() {
	# Inlined from games.eclass
	_games_ut_unpack() {
		local ut_unpack="${1}"
		local f=

		if [[ -z ${ut_unpack} ]] ; then
			die "You must provide an argument to games_ut_unpack"
		fi

		if [[ -f ${ut_unpack} ]] ; then
			uz2unpack "${ut_unpack}" "${ut_unpack%.uz2}" || die "failed uncompressing file ${ut_unpack}"
		fi

		if [[ -d ${ut_unpack} ]] ; then
			while read f ; do
				uz2unpack "${ut_unpack}/${f}" "${ut_unpack}/${f%.uz2}" || die "failed uncompressing file ${f}"
				rm -f "${ut_unpack}/${f}" || die "failed deleting compressed file ${f}"
			done < <(find "${ut_unpack}" -maxdepth 1 -name '*.uz2' -printf '%f\n' 2>/dev/null)
		fi
	}

	insinto "${dir}"
	# Disk 1
	einfo "Copying files from Disk 1..."
	doins -r "${CDROM_ROOT}"/{Animations,ForceFeedback,KarmaData,Maps,Sounds,Textures,Web}
	insinto "${dir}"/System
	doins -r "${CDROM_ROOT}"/System/{editorres,*.{bmp,dat,det,est,frt,ini,int,itt,md5,u,upl,url}}
	insinto "${dir}"/Benchmark/Stuff
	doins -r "${CDROM_ROOT}"/Benchmark/Stuff/*
	cdrom_load_next_cd

	# Disk 2
	insinto "${dir}"
	einfo "Copying files from Disk 2..."
	doins -r "${CDROM_ROOT}"/{Music,Sounds,StaticMeshes,Textures}
	cdrom_load_next_cd

	# Disk 3
	einfo "Copying files from Disk 3..."
	doins -r "${CDROM_ROOT}"/Sounds

	# TODO: move this to src_unpack, where it belongs
	unpack_makeself "${CDROM_ROOT}"/linux_installer.sh || die
	tar xf "${S}"/ut2003lnxbins.tar || die

	# create empty files in Benchmark
	for j in {CSVs,Logs,Results} ; do
		mkdir -p "${Ddir}"/Benchmark/${j} || die
		touch "${Ddir}"/Benchmark/${j}/DO_NOT_DELETE.ME || die
	done

	# Cleaning up our installation
	rm "${Ddir}"/System/{Build,Def{ault,User},Manifest,UT2003,User}.ini || die
	rm -f "${Ddir}"/System/{Core,Engine,Setup,UnrealGame,Window,XGame,XInterface,XWeapons}.{det,est,frt,int,itt,u} || die
	rm -rf "${Ddir}"/Web/ServerAdmin || die
	rm -f "${Ddir}"/System/{Editor,Fire,IpDrv,UnrealEd,Vehicles,XEffects,XPickups,XWebAdmin}.u || die
	rm -f "${Ddir}"/System/{UWeb,XAdmin}.{int,u} || die
	rm -f "${Ddir}"/System/GamePlay.{det,itt,u} || die
	rm -f "${Ddir}"/System/XMaps.{det,est} "${Ddir}"/System/Xweapons.itt || die
	rm -f "${Ddir}"/System/Manifest.int "${Ddir}"/System/Packages.md5 || die

	# install extra help files
	insinto "${dir}"/Help
	doins "${S}"/Help/Unreal.bmp

	# install Default and DefUser ini files
	insinto "${dir}"/System
	doins "${S}"/System/Def{ault,User}.ini

	# install EULA
	insinto "${dir}"
	doins "${S}"/eula/License.int

	# copying extra/updater
	doins -r "${S}"/{extras,updater}
	rm -f "${Ddir}"/updater/update || die

	# copy libraries
	exeinto "${dir}"/System
	doexe "${S}"/System/libSDL-1.2.so.0

	# uncompressing files
	einfo "Uncompressing files... this may take a while..."
	for j in {Animations,Maps,Sounds,StaticMeshes,Textures} ; do
		_games_ut_unpack "${Ddir}"/${j} || die "uncompressing files"
	done

	# installing documentation/icon
	dodoc "${S}"/README.linux
	newicon "${S}"/Unreal.xpm ut2003.xpm
	doins "${S}"/README.linux "${S}"/Unreal.xpm
	# copy ut2003/ucc
	exeinto "${dir}"
	doexe "${S}"/bin/ut2003 "${S}"/ucc

	# Here we apply DrSiN's crash patch
	cp "${S}"/CrashFix/System/crashfix.u "${Ddir}"/System || die

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
	sed -i -e "s:UplinkToGamespy=True:UplinkToGamespy=False:" \
		"${Ddir}"/System/Default.ini || die

	# now, since these files are coming off a cd, the times/sizes/md5sums wont
	# be different ... that means portage will try to unmerge some files (!)
	# we run touch on ${D} so as to make sure portage doesnt do any such thing
	find "${Ddir}" -exec touch '{}' + || die
}
