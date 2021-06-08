# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

MY_PN=Nexuiz
MY_P=${PN}-${PV//./}
MAPS=nexmappack_r2
DESCRIPTION="Deathmatch FPS based on DarkPlaces, an advanced Quake 1 engine"
HOMEPAGE="http://www.nexuiz.com/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip
	maps? ( mirror://sourceforge/${PN}/${MAPS}.zip )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa dedicated maps opengl sdl"

# no headers for libpng needed
UIRDEPEND="
	media-libs/libmodplug
	media-libs/libogg
	>=media-libs/libpng-1.4:0
	media-libs/libtheora
	media-libs/libvorbis
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libXxf86dga
	x11-libs/libXxf86vm
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	sdl? ( media-libs/libsdl[joystick,opengl,video] )"
UIDEPEND="x11-base/xorg-proto"
RDEPEND="virtual/jpeg:0
	net-misc/curl
	opengl? ( ${UIRDEPEND} )
	!dedicated? ( !opengl? ( ${UIRDEPEND} ) )"
DEPEND="${RDEPEND}
	app-arch/unzip
	opengl? ( ${UIDEPEND} )
	!dedicated? ( !opengl? ( ${UIDEPEND} ) )"

S=${WORKDIR}/darkplaces

PATCHES=(
	"${FILESDIR}"/${P}-libpng-1.4.patch
)

src_unpack() {
	unpack ${MY_P}.zip

	local f
	for f in "${MY_PN}"/sources/*.zip ; do
		unpack ./${f}
	done

	if use maps ; then
		cd "${WORKDIR}"/${MY_PN}
		unpack ${MAPS}.zip
	fi
}

src_prepare() {
	default

	# Make the game automatically look in the correct data directory
	sed -i \
		-e 's:-O2:$(CFLAGS):' \
		-e '/-lm/s:$: $(LDFLAGS):' \
		-e '/^STRIP/s/strip/true/' \
		makefile.inc || die

	sed -i \
		-e '1i DP_LINK_TO_LIBJPEG=1' \
		-e "s:ifdef DP_.*:DP_FS_BASEDIR=${EPREFIX}/usr/share/${PN}\n&:" \
		makefile || die

	if ! use alsa ; then
		sed -i \
			-e "/DEFAULT_SNDAPI/s:ALSA:OSS:" \
			makefile || die
	fi
}

src_compile() {
	# Unset STRIP because the build system by default will not strip
	# If users express a preference, this triggers strip
	# bug #739294
	unset STRIP

	tc-export CC

	if use opengl || ! use dedicated ; then
		emake cl-${PN}
		if use sdl ; then
			emake sdl-${PN}
		fi
	fi

	if use dedicated ; then
		emake sv-${PN}
	fi
}

src_install() {
	if use opengl || ! use dedicated ; then
		dobin ${PN}-glx
		doicon ${PN}.xpm
		make_desktop_entry ${PN}-glx "Nexuiz (GLX)"
		if use sdl ; then
			dobin ${PN}-sdl
			make_desktop_entry ${PN}-sdl "Nexuiz (SDL)"
			dosym ${PN}-sdl /usr/bin/${PN}
		else
			dosym ${PN}-glx /usr/bin/${PN}
		fi
	fi

	if use dedicated ; then
		dobin ${PN}-dedicated
	fi

	cd "${WORKDIR}"/${MY_PN} || die

	dodoc Docs/*.txt
	dodoc -r readme.html Docs

	insinto /usr/share/${PN}

	if use dedicated ; then
		doins -r server
	fi

	doins -r data havoc
}
