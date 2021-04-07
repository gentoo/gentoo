# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

MY_P="quake2-r${PV}"
DESCRIPTION="The icculus.org Linux port of iD's Quake 2 engine"
HOMEPAGE="http://icculus.org/quake2/"
SRC_URI="http://icculus.org/quake2/files/${MY_P}.tar.gz
	qmax? ( http://icculus.org/quake2/files/maxpak.pak )
	rogue? ( mirror://idsoftware/quake2/source/roguesrc320.shar.Z )
	xatrix? ( mirror://idsoftware/quake2/source/xatrixsrc320.shar.Z )"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aalib alsa cdinstall dedicated demo ipv6 joystick opengl qmax rogue sdl X xatrix"

UIDEPEND="aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	opengl? ( virtual/opengl )
	sdl? ( media-libs/libsdl[sound,joystick?,video] )
	X? (
		x11-libs/libXxf86dga
		x11-libs/libXxf86vm
	)"
RDEPEND="${UIDEPEND}
	cdinstall? ( games-fps/quake2-data )
	demo? ( games-fps/quake2-demodata )"
DEPEND="${UIDEPEND}
	X? ( x11-base/xorg-proto )
	rogue? ( app-arch/sharutils )
	xatrix? ( app-arch/sharutils )"

PATCHES=(
	# -amd64.patch # make sure this is still needed in future versions
	"${FILESDIR}"/${P}-amd64.patch
	"${FILESDIR}"/${P}-gentoo-paths.patch
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-no-asm-io.patch
	"${FILESDIR}"/${P}-gnusource.patch
	"${FILESDIR}"/${P}-x11_soft.patch
	"${FILESDIR}"/${P}-x11_mouse.patch
	"${FILESDIR}"/${P}-alsa.patch
	"${FILESDIR}"/${P}-ia64.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

pkg_setup() {
	if ! use qmax && $( use opengl || use sdl ) ; then
		elog "The 'qmax' graphical improvements are recommended."
		echo
	fi
}

src_prepare() {
	# Now we deal with the silly rogue / xatrix addons ... this is ugly :/
	ln -s $(type -P echo) "${T}"/more || die

	for g in rogue xatrix ; do
		use ${g} || continue
		mkdir -p src/${g} || die

		pushd src/${g} || die

		local shar=../../../${g}src320.shar
		sed -i -e 's:^read ans:ans=yes :' ${shar} || die
		elog "Unpacking ${shar} to ${PWD}"
		env PATH="${T}:${PATH}" unshar ${shar} || die

		popd || die
	done

	sed -i -e 's:jpeg_mem_src:_&:' src/ref_candygl/gl_image.c || die
	sed -i -e 's:BUILD_SOFTX:BUILD_X11:' Makefile || die

	default

	if use xatrix ; then
		eapply "${FILESDIR}/${P}"-gcc41.patch
	fi
	if use rogue ; then
		cd src || die
		eapply \
			"${FILESDIR}"/0.16-rogue-nan.patch \
			"${FILESDIR}"/0.16-rogue-armor.patch
	fi
}

yesno() {
	for f in "$@" ; do
		if ! use $f ; then
			echo NO
			return 1
		fi
	done
	echo YES
	return 0
}

src_compile() {
	# xatrix fails to build
	# rogue fails to build
	local libsuffix
	for BUILD_QMAX in YES NO ; do
		! use qmax && [[ ${BUILD_QMAX} == "YES" ]] && continue
		[[ ${BUILD_QMAX} == "YES" ]] \
			&& libsuffix=-qmax \
			|| libsuffix=
		emake -j1 clean
		emake -j1 build_release \
			BUILD_SDLQUAKE2=$(yesno sdl) \
			BUILD_SVGA=NO \
			BUILD_X11=$(yesno X) \
			BUILD_GLX=$(yesno opengl) \
			BUILD_SDL=$(yesno sdl) \
			BUILD_SDLGL=$(yesno sdl opengl) \
			BUILD_CTFDLL=YES \
			BUILD_XATRIX=$(yesno xatrix) \
			BUILD_ROGUE=$(yesno rogue) \
			BUILD_JOYSTICK=$(yesno joystick) \
			BUILD_DEDICATED=$(yesno dedicated) \
			BUILD_AA=$(yesno aalib) \
			BUILD_QMAX=${BUILD_QMAX} \
			HAVE_IPV6=$(yesno ipv6) \
			BUILD_ARTS=NO \
			BUILD_ALSA=$(yesno alsa) \
			SDLDIR=/usr/lib \
			DEFAULT_BASEDIR="/usr/share/quake2" \
			DEFAULT_LIBDIR="/usr/$(get_libdir)/${PN}${libsuffix}" \
			OPT_CFLAGS="${CFLAGS}" \
			CC="$(tc-getCC)"

		# now we save the build dir ... except for the object files ...
		rm release*/*/*.o || die
		mv release* my-rel-${BUILD_QMAX} || die
		cd my-rel-${BUILD_QMAX} || die
		rm -rf ref_{gl,soft} ded game client ctf/*.o || die
		mkdir baseq2 || die
		mv game*.so baseq2/ || die
		cd .. || die
	done
}

src_install() {
	local q2dir=/usr/$(get_libdir)/${PN}
	local q2maxdir=/usr/$(get_libdir)/${PN}-qmax

	dodoc readme.txt README TODO "${FILESDIR}"/README-postinstall

	# regular q2 files
	dodir "${q2dir}"
	cp -rf my-rel-NO/* "${ED}/${q2dir}"/ || die

	dobin "${ED}/${q2dir}"/quake2
	rm "${ED}/${q2dir}"/quake2 || die

	use dedicated \
		&& dobin "${ED}/${q2dir}"/q2ded \
		&& rm "${ED}/${q2dir}"/q2ded
	use sdl \
		&& dobin "${ED}/${q2dir}"/sdlquake2 \
		&& rm "${ED}/${q2dir}"/sdlquake2

	doicon "${FILESDIR}"/quake2.xpm
	make_desktop_entry quake2 "Quake 2" quake2

	# q2max files
	if use qmax ; then
		dodir "${q2maxdir}"

		cp -rf my-rel-YES/* "${ED}/${q2maxdir}"/ || die

		newbin "${ED}/${q2maxdir}"/quake2 quake2-qmax
		rm "${ED}/${q2maxdir}"/quake2 || die

		if use dedicated ; then
			newbin "${ED}/${q2maxdir}"/q2ded q2ded-qmax
			rm "${ED}/${q2maxdir}"/q2ded || die
		fi

		if use sdl ; then
			newbin "${ED}/${q2maxdir}"/sdlquake2 sdlquake2-qmax
			rm "${ED}/${q2maxdir}"/sdlquake2 || die
		fi

		insinto "${q2maxdir}"/baseq2
		doins "${DISTDIR}"/maxpak.pak

		make_desktop_entry quake2-qmax Quake2-qmax quake2
	fi
}

pkg_postinst() {
	elog "Go read README-postinstall in /usr/share/doc/${PF}"
	elog "right now! It's important - this install is just the engine, you still need"
	elog "the data paks. Go read."

	if use demo && ! has_version "games-fps/quake2-demodata[symlink]" ; then
		ewarn "To play the Quake 2 demo,"
		ewarn "emerge games-fps/quake2-demodata with the 'symlink' USE flag."
		echo
	fi
}
