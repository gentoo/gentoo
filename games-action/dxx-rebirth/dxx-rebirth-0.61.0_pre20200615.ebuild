# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit desktop eutils python-any-r1 scons-utils toolchain-funcs xdg
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dxx-rebirth/dxx-rebirth"
else
	# dxx-rebirth-0.61.0_pre20190720.ebuild
	#MY_COMMIT='a17792c89fd49dd12fdf5981670dd7f64b42850f'
	# dxx-rebirth-0.61.0_pre20200615.ebuild
	MY_COMMIT='0c2fcf691ffb2a586991350d67f3efd1cca2a1f3'
	# dxx-rebirth-0.61.0_pre20200627.ebuild
	#MY_COMMIT='aba40babb47d36a88011af01e4bc0fc00dca74ef'
	S="${WORKDIR}/${P}N-${MY_COMMIT}"
	#SRC_URI="https://github.com/dxx-rebirth/dxx-rebirth/archive/${MY_COMMIT}.tar.gz -> ${PN}-${PVR}.tar.gz"
	SRC_URI="https://codeload.github.com/dxx-rebirth/dxx-rebirth/tar.gz/${MY_COMMIT} -> ${PN}-${PVR}.tar.gz"
	unset MY_COMMIT

	# Games under Gentoo are marked as 'testing' by convention
	#
	# Other architectures are reported to work, but not tested regularly by
	# the core team.
	#
	# Raspberry Pi support is tested by an outside contributor, and his
	# fixes are merged into the main source by upstream.
	#
	# Cross-compilation to Windows is also supported.
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Descent Rebirth - enhanced Descent 1 & 2 engine"
HOMEPAGE="https://www.dxx-rebirth.com/"

LICENSE="DXX-Rebirth GPL-3"
SLOT="0"

# Default to building both game engines.  The total size is relatively
# small.
IUSE="+d1x +d2x +data debug editor +flac ipv6 +joystick l10n_de +midi +mp3 +music +opengl opl3-musicpack +png sc55-musicpack sdl2 tracker valgrind +vorbis"

# Game data is stored in HOG files.
# Game movies are in MVL files.
# Various add-ons use zip files to bundle their content together.
#
# PNG support enables writing screenshots as PNG instead of TGA (for
# USE=opengl) or PCX (for USE=-opengl).
DEPEND="dev-games/physfs[hog,mvl,zip]
	opengl? (
		virtual/opengl
		virtual/glu )
	png? ( media-libs/libpng )
"

# As of this writing, there is no Portage shorthand syntax to express:
# "
# 	flag1? ( package[flag1] )
# 	flag2? ( package[flag2] )
# 	...
# 	flagN? ( package[flagN] )
# ", such that unsetting all flags removes the dependency on package.
# Fake it by using a text fragment that is repeatedly expanded with
# differing substitutions.
#
# The use of single quotes is intentional here.  The ${word} is a
# placeholder to be matched by text substitution when the fragment is
# expanded, not a shell variable reference.
#
# For each flag, depend on freedata using the same flag.  If none of the
# flags are set, freedata is not needed.
DXX_RDEPEND_USE_FREEDATA_FRAGMENT='
	${USE}? ( games-action/descent${ENGINE}-freedata[${USE}] )
'
# Block <0.59.100 due to file collision.
#
# If USE=data, then require a game data package.
# The build process does not use the game data, nor change how the game
# is built based on what game data will be used.  At startup, the game
# will search for both types of game data and use what it finds.  Users
# can switch between shareware/retail data at any time by
# adding/removing the appropriate data packages.  A rebuild is _not_
# required after swapping the data files.
#
# USE-depend on freedata for various extras, but only if any of those
# extras are enabled.
DXX_RDEPEND_ENGINE_FRAGMENT='
	d${ENGINE}x? (
		!<games-action/d${ENGINE}x-rebirth-0.59.100
		data? (
			|| (
				games-action/descent${ENGINE}-data
				games-action/descent${ENGINE}-demodata
			)
		)
		'"
		${DXX_RDEPEND_USE_FREEDATA_FRAGMENT//\$\{USE\}/l10n_de}
		${DXX_RDEPEND_USE_FREEDATA_FRAGMENT//\$\{USE\}/opl3-musicpack}
		${DXX_RDEPEND_USE_FREEDATA_FRAGMENT//\$\{USE\}/sc55-musicpack}
		"'
	)
'

DXX_DEPEND_USE_SDL_VERSION_FRAGMENT='
	media-libs/lib${SDL_version}[joystick?,opengl?,sound,video]
	media-libs/${SDL_version}-image
	music? ( media-libs/${SDL_version}-mixer )
'
DXX_RDEPEND_USE_SDL_VERSION_FRAGMENT='
	music? ( media-libs/${SDL_version}-mixer[flac?,midi?,mp3?,vorbis?] )
'
DEPEND="${DEPEND}
	!sdl2? ( ${DXX_DEPEND_USE_SDL_VERSION_FRAGMENT//\$\{SDL_version\}/sdl} )
	sdl2? ( ${DXX_DEPEND_USE_SDL_VERSION_FRAGMENT//\$\{SDL_version\}/sdl2} )
"
unset DXX_DEPEND_USE_SDL_VERSION_FRAGMENT

unset DXX_RDEPEND_USE_FREEDATA_FRAGMENT
RDEPEND="${DEPEND}
	!sdl2? ( ${DXX_RDEPEND_USE_SDL_VERSION_FRAGMENT//\$\{SDL_version\}/sdl} )
	sdl2? ( ${DXX_RDEPEND_USE_SDL_VERSION_FRAGMENT//\$\{SDL_version\}/sdl2} )
	${DXX_RDEPEND_ENGINE_FRAGMENT//\$\{ENGINE\}/1}
	${DXX_RDEPEND_ENGINE_FRAGMENT//\$\{ENGINE\}/2}
"
unset DXX_RDEPEND_ENGINE_FRAGMENT
unset DXX_RDEPEND_USE_SDL_VERSION_FRAGMENT

# USE=valgrind enables use of a Valgrind header.  A build with valgrind
# instrumentation can be run without installing Valgrind, so this
# dependency is only in DEPEND, instead of being in both DEPEND and
# RDEPEND.
DEPEND+='
	valgrind? ( dev-util/valgrind )
'

# This ebuild builds d1x-rebirth, d2x-rebirth, or both.  Building none
# would mean this ebuild installs zero files.
#
# For each of the supported music flags, require USE=music, so that the
# package is built with sdl-mixer support.  Individual music types can be
# changed without a Rebirth rebuild by rebuilding sdl-mixer with
# appropriate support, but Rebirth must have sdl-mixer support at build
# time in order to support any of these music formats at runtime.
#
# All music files in the optional musicpack downloads are .ogg, so
# require USE=vorbis if those packs are enabled.
REQUIRED_USE='
	|| ( d1x d2x )
	flac? ( music )
	midi? ( music )
	mp3? ( music )
	vorbis? ( music )
	opl3-musicpack? ( vorbis )
	sc55-musicpack? ( vorbis )
	sdl2? ( opengl )
'

# As of this writing, IUSE_RUNTIME is a GLEP, but not an implemented
# feature.  This variable is stored here to be ready to activate when
# Portage implements this feature.
#
# Note that while individual music formats can be switched without a
# rebuild, the master flag USE=music controls whether sdl-mixer is used,
# and therefore requires a rebuild when changed.
#IUSE_RUNTIME="flac l10n_de midi mp3 opl3-musicpack sc55-musicpack vorbis"

dxx_scons() {
	# Always build profile `m`.  If use editor, also build profile `e`.
	# Set most variables in the default anonymous profile.  Only
	# `builddir` and `editor` are set in the named profiles, since those
	# must be different between the two builds.
	#
	# Notes for end users:
	# - Per-engine options can be set with an engine prefix, as shown
	#   for sharepath.  Such options are used in place of
	#   engine-unqualified options.  For example, to disable sdlmixer
	#   for Descent 2: Rebirth, but use the setting below for Descent 1:
	#   Rebirth, set EXTRA_ESCONS="d2x_sdlmixer=0".
	# - Profile `site` is searched before the anonymous profile, and is
	#   deliberately unused in this ebuild.  Set options in the site
	#   profile to affect both engines:
	#   EXTRA_ESCONS="site_verbosebuild=0".
	local scons_build_profile=m mysconsargs=(
		sdl2=$(usex sdl2 1 0)
		sdlmixer=$(usex music 1 0)
		verbosebuild=1
		debug=$(usex debug 1 0)
		ipv6=$(usex ipv6 1 0)
		opengl=$(usex opengl 1 0)
		use_tracker=$(usex tracker 1 0)
		prefix="${EPREFIX}"/usr
		screenshot=$(usex png png legacy)
		m_builddir=build/main/
		m_editor=0
	)
	if use editor; then
		scons_build_profile+=+e
		mysconsargs+=( \
			e_builddir=build/editor/
			e_editor=1
		)
	fi
	if ! use joystick; then
		mysconsargs+=( \
			max_joysticks=0
		)
	fi
	# Add sharepath and enable build of selected games.  The trailing
	# comma after `$scons_build_profile` is required to cause scons to
	# search the anonymous profile.  If omitted, only settings from the
	# named profile would be used.
	use d1x && mysconsargs+=( d1x_sharepath="/usr/share/games/d1x" d1x="$scons_build_profile,site," )
	use d2x && mysconsargs+=( d2x_sharepath="/usr/share/games/d2x" d2x="$scons_build_profile,site," )
	use valgrind && mysconsargs+=( poison=valgrind )
	escons "${mysconsargs[@]}" "$@"
}

src_compile() {
	tc-export CXX PKG_CONFIG
	dxx_scons register_install_target=0 build
}

src_install() {
	# Use upstream install target to handle the various combinations of
	# enabled/disabled engines and optional editor support.
	dxx_scons register_compile_target=0 register_install_target=1 DESTDIR="${D}" "${D}"
	local DV
	for DV in 1 2; do
		if ! use d${DV}x; then
			continue
		fi
		local PROGRAM=d${DV}x-rebirth
		docinto "${PROGRAM}"
		dodoc "${PROGRAM}"/*.txt
		make_desktop_entry "${PROGRAM}" "Descent ${DV} Rebirth" "${PROGRAM}"
		doicon "${PROGRAM}/${PROGRAM}.xpm"
	done
}

pkg_postinst() {
	xdg_pkg_postinst
	if ! use data; then
		elog "${PN} requires game data to play."
		elog "Game data is not included in this package.  To play the game,"
		elog "emerge the packages required by USE=data or install the game"
		elog "data by hand."
		elog
		elog "Changing USE=data does not change how this package is built,"
		elog "only its runtime dependencies."
	fi
}
