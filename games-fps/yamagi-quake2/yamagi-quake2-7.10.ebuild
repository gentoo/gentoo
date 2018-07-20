# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop eutils

CTF_V=1.05
ROGUE_V=2.04
XATRIX_V=2.05

DESCRIPTION="Quake 2 engine focused on single player"
HOMEPAGE="https://www.yamagi.org/quake2/"
SRC_URI="https://deponie.yamagi.org/quake2/quake2-${PV}.tar.xz
	ctf? ( https://deponie.yamagi.org/quake2/quake2-ctf-${CTF_V}.tar.xz )
	rogue? ( https://deponie.yamagi.org/quake2/quake2-rogue-${ROGUE_V}.tar.xz )
	xatrix? ( https://deponie.yamagi.org/quake2/quake2-xatrix-${XATRIX_V}.tar.xz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+client ctf dedicated ogg openal rogue xatrix"
REQUIRED_USE="|| ( client dedicated )"

RDEPEND="sys-libs/zlib:0=
	client? (
		media-libs/libsdl2[opengl,video]
		virtual/opengl
		ogg? (
			media-libs/libogg
			media-libs/libvorbis
		)
		openal? ( media-libs/openal )
		!openal? ( media-libs/libsdl2[sound] )
	)
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/quake2-${PV}"

PATCHES=( "${FILESDIR}"/${PN}-respect-flags.patch )
DOCS=( CHANGELOG CONTRIBUTE README.md )

mymake() {
	emake \
		VERBOSE=1 \
		DLOPEN_OPENAL=no \
		WITH_CDA=no \
		WITH_SYSTEMWIDE=yes \
		WITH_SYSTEMDIR="${EPREFIX}"/usr/share/games/quake2 \
		WITH_ZIP=yes \
		WITH_OGG=$(usex ogg) \
		WITH_OPENAL=$(usex openal) \
		"$@"
}

src_prepare() {
	local addon
	for addon in ctf rogue xatrix; do
		use ${addon} || continue

		pushd "${WORKDIR}"/quake2-${addon}-* >/dev/null || die
		eapply -l -- "${FILESDIR}"/${PN}-addon-respect-flags.patch
		popd >/dev/null || die
	done

	default
}

src_compile() {
	local targets=( game )
	use client && targets+=( client ref_gl1 ref_gl3 )
	use dedicated && targets+=( server )

	mymake config
	mymake "${targets[@]}"

	local addon
	for addon in ctf rogue xatrix; do
		use ${addon} || continue
		emake -C "${WORKDIR}"/quake2-${addon}-* VERBOSE=1
	done
}

src_install() {
	insinto /usr/lib/yamagi-quake2
	# Yamagi Quake II expects all binaries to be in the same directory
	# See stuff/packaging.md for more info
	exeinto /usr/lib/yamagi-quake2
	doins -r release/.

	if use client; then
		doexe release/quake2
		dosym ../lib/yamagi-quake2/quake2 /usr/bin/yquake2

		newicon stuff/icon/Quake2.svg "yamagi-quake2.svg"
		make_desktop_entry "yquake2" "Yamagi Quake II"
	fi

	if use dedicated; then
		doexe release/q2ded
		dosym ../lib/yamagi-quake2/q2ded /usr/bin/yq2ded
	fi

	insinto /usr/lib/yamagi-quake2/baseq2
	doins stuff/yq2.cfg

	local addon
	for addon in ctf rogue xatrix; do
		use ${addon} || continue

		insinto /usr/lib/yamagi-quake2/${addon}
		doins "${WORKDIR}"/quake2-${addon}-*/release/game.so

		local addon_name
		case ${addon} in
			ctf)    addon_name="CTF" ;;
			rogue)  addon_name="Ground Zero" ;;
			xatrix) addon_name="The Reckoning" ;;
		esac

		make_wrapper "yquake2-${addon}" "yquake2 +set game ${addon}"
		make_desktop_entry "yquake2-${addon}" "Yamagi Quake II: ${addon_name}"
	done

	einstalldocs
	if use client; then
		docinto examples
		dodoc stuff/cdripper.sh
	fi
}
