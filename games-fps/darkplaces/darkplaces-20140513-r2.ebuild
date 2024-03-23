# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic toolchain-funcs wrapper unpacker

# Latest versions are in http://icculus.org/twilight/darkplaces/files/
MY_PV="${PV/_beta/beta}"
MY_ENGINE="${PN}engine${MY_PV}.zip"

# Different Quake 1 engines expect the lights in different directories
# http://www.fuhquake.net/download.html and http://www.kgbsyndicate.com/romi/
MY_LIGHTS="fuhquake-lits.rar"

DESCRIPTION="Enhanced engine for iD Software's Quake 1"
HOMEPAGE="http://icculus.org/twilight/darkplaces/"
SRC_URI="http://icculus.org/twilight/${PN}/files/${MY_ENGINE}
	lights? (
		http://www.fuhquake.net/files/extras/${MY_LIGHTS}
		http://www.kgbsyndicate.com/romi/id1.pk3 )"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa cdinstall cdsound debug dedicated demo lights opengl oss sdl textures"

UIRDEPEND="
	virtual/jpeg:0
	media-libs/libogg
	media-libs/libvorbis
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	sdl? ( media-libs/libsdl[joystick] )
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXxf86dga
	x11-libs/libXxf86vm
"
UIDEPEND="
	x11-base/xorg-proto
"
RDEPEND="
	net-misc/curl
	cdinstall? ( games-fps/quake1-data )
	demo? ( games-fps/quake1-demodata )
	textures? ( >=games-fps/quake1-textures-20050820 )
	opengl? ( ${UIRDEPEND} )
	!opengl? ( sdl? ( ${UIRDEPEND} ) )
	!opengl? ( !sdl? ( !dedicated? ( ${UIRDEPEND} ) ) )
"
DEPEND="lights? ( || (
			app-arch/unrar
			app-arch/rar ) )
	opengl? (
		${UIRDEPEND}
		${UIDEPEND} )
	!opengl? ( sdl? (
		${UIRDEPEND}
		${UIDEPEND} ) )
	!opengl? ( !sdl? ( !dedicated? (
		${UIRDEPEND}
		${UIDEPEND} ) ) )
"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
"

PATCHES=("${FILESDIR}"/${P}-gcc-11.patch)

dir="/usr/share/quake1"

opengl_client() {
	use opengl || ( ! use dedicated && ! use sdl )
}

src_unpack() {
	if use lights ; then
		unpack "${MY_LIGHTS}"
		unpack_zip "${DISTDIR}"/id1.pk3
		mv *.lit maps/ || die
		mv ReadMe.txt rtlights.txt
	fi

	unpack "${MY_ENGINE}"
	unpack ./${PN}*.zip
}

src_prepare() {
	default

	rm "${WORKDIR}"/README-SDL.txt
	cd "${S}"
	rm mingw_note.txt

	strip-flags

	# Only additional CFLAGS optimization is the -march flag
	local march=$(get-flag -march)
	sed -i \
		-e "s:-lasound:$($(tc-getPKG_CONFIG) --libs alsa):" \
		-e "/^CPUOPTIMIZATIONS/d" \
		-e '/^OPTIM_RELEASE/s/=.*/=$(CFLAGS)/' \
		-e '/^OPTIM_DEBUG/s/=.*/=$(CFLAGS)/' \
		-e '/^LDFLAGS_DEBUG/s/$/ $(LDFLAGS)/' \
		-e '/^LDFLAGS_RELEASE/s/$/ $(LDFLAGS)/' \
		-e "s:strip:true:" \
		makefile.inc || die

	if ! use cdsound ; then
		# Turn the CD accesses off
		sed -i \
			-e "s:/dev/cdrom:/dev/null:" \
			cd_linux.c || die
		sed -i \
			-e 's:COM_CheckParm("-nocdaudio"):1:' \
			cd_shared.c || die
	fi
}

src_compile() {
	local opts="DP_FS_BASEDIR=\"${dir}\" DP_LINK_TO_LIBJPEG=1"

	# Protect against people choosing a strip implementation
	# bug #739194
	unset STRIP

	# Strict aliasing violations (bug #858740), but they seem to be fixed in git.
	# Check on next release (>20140513) / snapshot.
	append-flags -fno-strict-aliasing
	filter-lto

	tc-export CC

	# Preferred sound is alsa
	local sound_api="NULL"
	use oss && sound_api="OSS"
	use alsa && sound_api="ALSA"
	opts="${opts} DP_SOUND_API=${sound_api}"

	local type="release"
	use debug && type="debug"

	# Only compile a maximum of 1 client
	if use sdl ; then
		emake ${opts} "sdl-${type}"
	elif opengl_client ; then
		emake ${opts} "cl-${type}"
	fi

	if use dedicated ; then
		emake ${opts} "sv-${type}"
	fi
}

src_install() {
	if opengl_client || use sdl ; then
		local type=glx

		use sdl && type=sdl

		# darkplaces executable is needed, even just for demo
		newbin "${PN}-${type}" ${PN}
		newicon darkplaces72x72.png ${PN}.png

		if use demo ; then
			# Install command-line for demo, even if not desktop entry
			make_wrapper ${PN}-demo "${PN} -game demo"
		fi

		if use demo && ! use cdinstall ; then
			make_desktop_entry ${PN}-demo "Dark Places (Demo)"
		else
			# Full version takes precedence over demo
			make_desktop_entry ${PN} "Dark Places"
		fi
	fi

	if use dedicated ; then
		newbin ${PN}-dedicated ${PN}-ded
	fi

	dodoc *.txt ChangeLog todo "${WORKDIR}"/*.txt

	if use lights ; then
		insinto "${dir}"/id1
		doins -r "${WORKDIR}"/{cubemaps,maps}

		if use demo ; then
			# Set up symlinks, for the demo levels to include the lights
			local d
			for d in cubemaps maps ; do
				dosym "${dir}/id1/${d}" "${dir}/demo/${d}"
			done
		fi
	fi
}

pkg_postinst() {
	if ! use cdinstall && ! use demo ; then
		elog "Place pak0.pak and pak1.pak in ${dir}/id1"
	fi

	if use sdl && ! use alsa ; then
		ewarn "Select opengl with alsa, instead of sdl USE flag, for better audio latency."
	fi
}
