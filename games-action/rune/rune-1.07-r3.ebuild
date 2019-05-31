# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils cdrom

DESCRIPTION="Viking hack and slay game"
HOMEPAGE="http://www.runegame.com"
SRC_URI="mirror://gentoo/rune-all-0.2.tar.bz2"

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip mirror bindist"

RDEPEND="dev-util/xdelta:0
	>=media-libs/libsdl-1.2.9-r1[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]"

S=${WORKDIR}

dir=/opt/${PN}
Ddir=${D}/${dir}

src_unpack() {
	export CDROM_SET_NAMES=("Linux Rune CD" "Windows Rune CD")
	cdrom_get_cds System/rune-bin:System/Rune.exe
	dodir "${dir}"
	if [[ ${CDROM_SET} -eq 0 ]]
	then
		# unpack the data files
		tar xzf "${CDROM_ROOT}"/data.tar.gz || die
	elif [[ ${CDROM_SET} -eq 1 ]]
	then
		# unpack the runelinuxfiles.tar.gz
		unpack ${A}
	fi
}

src_install() {
	insinto "${dir}"
	exeinto "${dir}"
	einfo "Copying files... this may take a while..."

	case ${CDROM_SET} in
	0)
		for x in Help Maps Meshes Sounds System Textures Web
		do
			doins -r $x
		done

		# copy linux specific files
		doins -r "${CDROM_ROOT}"/System

		# the most important things: rune and ucc :)
		doexe "${CDROM_ROOT}"/bin/x86/rune
		fperms 750 "${dir}"/System/{ucc{,-bin},rune-bin}

		# installing documentation/icon
		dodoc "${CDROM_ROOT}"/{README,CREDITS}
		newicon "${CDROM_ROOT}"/icon.xpm rune.xpm
	;;
	1)
		# copying Maps Sounds and Web
		for x in Maps Sounds Web
		do
			doins -r "${CDROM_ROOT}"/$x
		done

		# copying the texture files
		dodir "${dir}"/Textures
		for x in $(find "${CDROM_ROOT}"/Textures/ -type f -printf '%f ')
		do
			echo -ne '\271\325\036\214' | cat - "${CDROM_ROOT}"/Textures/$x \
				| sed -e '1 s/\(....\)..../\1/' > "${Ddir}"/Textures/$x \
				|| die
		done

		doins -r "${S}"/System
		doins -r "${S}"/Help
		sed -e "s:.*\(\w+/\w+\)\w:\1:"
		for x in $(ls "${S}"/patch/{System,Maps,Meshes} | sed -e \
			"s:.*/\([^/]\+/[^/]\+\).patch$:\1:")
		do
			xdelta patch "${S}"/patch/${x}.patch "${CDROM_ROOT}"/${x} "${S}"/patch/${x}
			doins "${S}"/patch/${x}
		done

		insinto "${dir}"/System

		# copying system files from the Windows CD
		for x in "${CDROM_ROOT}"/System/*.{int,u,url}; do
			doins $x
		done

		# modify the files
		mv "${Ddir}"/System/OpenGlDrv.int "${Ddir}"/System/OpenGLDrv.int \
			|| die
		mv "${Ddir}"/Textures/bloodFX.utx "${Ddir}"/Textures/BloodFX.utx \
			|| die
		mv "${Ddir}"/Textures/RUNESTONES.UTX "${Ddir}"/Textures/RUNESTONES.utx \
			|| die
		mv "${Ddir}"/Textures/tedd.utx "${Ddir}"/Textures/Tedd.utx \
			|| die
		mv "${Ddir}"/Textures/UNDERANCIENT.utx "${Ddir}"/Textures/UnderAncient.utx \
			|| die
		rm "${Ddir}"/System/{Setup.int,SGLDrv.int,MeTaLDrv.int,Manifest.int,D3DDrv.int,Galaxy.int,SoftDrv.int,WinDrv.int,Window.int} \
			|| die

		# the most important things: rune and ucc :)
		doexe "${S}"/bin/x86/rune
		fperms 750 "${dir}"/System/{ucc,ucc-bin,rune-bin}

		# installing documentation/icon
		dodoc "${S}"/{README,CREDITS}
		doicon "${S}"/rune.xpm rune.xpm
	;;
	esac

	use amd64 && mv "${Ddir}"/System/libSDL-1.2.so.0 \
		"${Ddir}"/System/libSDL-1.2.so.0.backup

	make_wrapper rune ./rune "${dir}" "${dir}"
	make_desktop_entry rune "Rune" rune
	find "${Ddir}" -exec touch '{}' \; || die
}
