# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3/quake3-1.36-r1.ebuild,v 1.6 2014/08/12 12:01:00 vapier Exp $

# quake3-9999          -> latest svn
# quake3-9999.REV      -> use svn REV
# quake3-VER_alphaREV  -> svn snapshot REV for version VER
# quake3-VER           -> normal quake release

EAPI=2
inherit eutils flag-o-matic games toolchain-funcs
[[ "${PV}" == 9999* ]] && inherit subversion

MY_PN="ioquake3"
MY_PV="${PV}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Quake III Arena - 3rd installment of the classic id 3D first-person shooter"
HOMEPAGE="http://ioquake3.org/"
[[ "${PV}" != 9999* ]] && SRC_URI="http://ioquake3.org/files/${MY_PV}/${MY_P}.tar.bz2"
ESVN_REPO_URI="svn://svn.icculus.org/quake3/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc x86 ~x86-fbsd"
# "smp" is omitted, because currently it does not work.
IUSE="dedicated opengl teamarena +openal curl vorbis voice mumble"

UIDEPEND="virtual/opengl
	media-libs/libsdl[sound,video,joystick,X,opengl]
	openal? ( media-libs/openal )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	voice? ( media-libs/speex )
	curl? ( net-misc/curl )"
DEPEND="opengl? ( ${UIDEPEND} )
	!dedicated? ( ${UIDEPEND} )"
UIRDEPEND="voice? ( mumble? ( media-sound/mumble ) )"
RDEPEND="${DEPEND}
	opengl? ( ${UIRDEPEND} )
	!dedicated? ( ${UIRDEPEND} )
	games-fps/quake3-data
	teamarena? ( games-fps/quake3-teamarena )"

if [[ "${PV}" == 9999* ]] ; then
	S="${WORKDIR}/trunk"
else
	S="${WORKDIR}/${MY_P}"
fi

my_arch() {
	case "${ARCH}" in
		x86)    echo "i386" ;;
		amd64)  echo "x86_64" ;;
		*)      tc-arch-kernel ;;
	esac
}

my_platform() {
	usex kernel_linux linux freebsd
}

src_prepare() {
	if [[ "${PV}" == 9999* ]] ; then
		# Workaround for the version string
		ln -s "${ESVN_WC_PATH}/.svn" .svn || die "ln ${ESVN_WC_PATH}/.svn"
	else
		epatch "${FILESDIR}"/${P}-bots.patch
	fi

	einfo "Fixing libspeex linking..."
	sed -i -e 's/\(-lspeex\)/\1 -lspeexdsp/' Makefile || die "sed failed"

	# Use system jpeg library
#	epatch "${FILESDIR}"/${P}-remove-bundled-jpeg.patch
}

src_compile() {

	buildit() { use $1 && echo 1 || echo 0 ; }

	# This is the easiest way to pass CPPFLAGS to the build system, which
	# are otherwise ignored.
	append-flags ${CPPFLAGS}

	# OPTIMIZE is disabled in favor of CFLAGS.
	#
	# TODO: BUILD_CLIENT_SMP=$(buildit smp)
	emake \
		ARCH="$(my_arch)" \
		BUILD_CLIENT=$(( $(buildit opengl) | $(buildit !dedicated) )) \
		BUILD_GAME_QVM=0 \
		BUILD_GAME_SO=0 \
		BUILD_SERVER=$(buildit dedicated) \
		DEFAULT_BASEDIR="${GAMES_DATADIR}/${PN}" \
		GENERATE_DEPENDENCIES=0 \
		OPTIMIZE="" \
		PLATFORM="$(my_platform)" \
		USE_CODEC_VORBIS=$(buildit vorbis) \
		USE_CURL=$(buildit curl) \
		USE_CURL_DLOPEN=0 \
		USE_INTERNAL_SPEEX=0 \
		USE_INTERNAL_ZLIB=0 \
		USE_LOCAL_HEADERS=0 \
		USE_MUMBLE=$(buildit mumble) \
		USE_OPENAL=$(buildit openal) \
		USE_OPENAL_DLOPEN=0 \
		USE_VOIP=$(buildit voice) \
		|| die "emake failed"
}

src_install() {
	dodoc BUGS ChangeLog id-readme.txt md4-readme.txt NOTTODO README TODO || die
	if use voice ; then
		dodoc voip-readme.txt || die
	fi

	if use opengl || ! use dedicated ; then
		doicon misc/quake3.svg || die
		make_desktop_entry quake3 "Quake III Arena"
		#use smp && make_desktop_entry quake3-smp "Quake III Arena (SMP)"
	fi

	cd build/release-$(my_platform)-$(my_arch) || die
	local exe target
	for exe in {ioquake3,ioquake3-smp,ioq3ded}.$(my_arch) ; do
		if [[ -x ${exe} ]] ; then
			target=${exe%.*}
			newgamesbin ${exe} ${target} || die "newgamesbin ${target}"
			dosym ${target} "${GAMES_BINDIR}/${target/io}" || die "dosym ${target}"
		fi
	done

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	ewarn "The source version of Quake III Arena will not work with PunkBuster."
	ewarn "If you need PB support, then use the games-fps/quake3-bin package."
}
