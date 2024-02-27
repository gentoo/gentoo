# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs wrapper

CTF_V="1.10"
ROGUE_V="2.11"
XATRIX_V="2.12"
REF_VK_V="1.0.7"

DESCRIPTION="Quake 2 engine focused on single player"
HOMEPAGE="https://www.yamagi.org/quake2/"
SRC_URI="https://deponie.yamagi.org/quake2/quake2-${PV}.tar.xz
	ctf? ( https://deponie.yamagi.org/quake2/quake2-ctf-${CTF_V}.tar.xz )
	rogue? ( https://deponie.yamagi.org/quake2/quake2-rogue-${ROGUE_V}.tar.xz )
	xatrix? ( https://deponie.yamagi.org/quake2/quake2-xatrix-${XATRIX_V}.tar.xz )
	vulkan? ( https://github.com/yquake2/ref_vk/archive/refs/tags/v${REF_VK_V}.tar.gz ->
		quake2-ref_vk-${REF_VK_V}.tar.gz )
"
S="${WORKDIR}/quake2-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="+client ctf dedicated gles openal +opengl rogue softrender vulkan xatrix"
REQUIRED_USE="
	|| ( client dedicated )
	client? ( || ( opengl gles softrender vulkan ) )
"

RDEPEND="
	client? (
		media-libs/libsdl2[opengl?,video,vulkan?]
		net-misc/curl
		gles? (
			media-libs/libglvnd
			media-libs/libsdl2[gles2]
		)
		openal? ( media-libs/openal )
		!openal? ( media-libs/libsdl2[sound] )
		opengl? ( media-libs/libglvnd[X] )
	)
"
DEPEND="${RDEPEND}
	client? ( vulkan? ( dev-util/vulkan-headers ) )
"

PATCHES=( "${FILESDIR}"/${PN}-8.01-execinfo.patch )

DOCS=( CHANGELOG README.md doc )

src_compile() {
	tc-export CC

	local targets=( game )
	local emakeargs=(
		VERBOSE=1
		WITH_EXECINFO=$(usex elibc_musl no yes)
		WITH_SYSTEMWIDE=yes
		WITH_SYSTEMDIR="${EPREFIX}"/usr/share/quake2
		WITH_OPENAL=$(usex openal)
	)

	if use client; then
		targets+=( client )
		use gles && targets+=( ref_gles3 )
		use opengl && targets+=( ref_gl1 ref_gl3 )
		use softrender && targets+=( ref_soft )
	fi
	use dedicated && targets+=( server )

	emake "${emakeargs[@]}" config
	emake "${emakeargs[@]}" "${targets[@]}"

	if use client && use vulkan; then
		emake -C "${WORKDIR}"/ref_vk-${REF_VK_V} VERBOSE=1
	fi

	local addon
	for addon in $(usev ctf) $(usev rogue) $(usev xatrix); do
		emake -C "${WORKDIR}"/quake2-${addon}-* VERBOSE=1
	done
}

src_install() {
	insinto /usr/lib/yamagi-quake2
	# Yamagi Quake II expects all binaries to be in the same directory
	# See doc/070_packaging.md for more info
	exeinto /usr/lib/yamagi-quake2
	doins -r release/.

	if use client; then
		doexe release/quake2
		dosym ../lib/yamagi-quake2/quake2 /usr/bin/yquake2

		newicon stuff/icon/Quake2.svg "yamagi-quake2.svg"
		make_desktop_entry "yquake2" "Yamagi Quake II"

		if use vulkan; then
			doins "${WORKDIR}"/ref_vk-${REF_VK_V}/release/ref_vk.so
		fi
	fi

	if use dedicated; then
		doexe release/q2ded
		dosym ../lib/yamagi-quake2/q2ded /usr/bin/yq2ded
	fi

	insinto /usr/lib/yamagi-quake2/baseq2
	doins stuff/yq2.cfg

	local addon
	for addon in $(usev ctf) $(usev rogue) $(usev xatrix); do
		insinto /usr/lib/yamagi-quake2/${addon}
		doins "${WORKDIR}"/quake2-${addon}-*/release/game.so

		if use client; then
			local addon_name
			case ${addon} in
				ctf)    addon_name="CTF" ;;
				rogue)  addon_name="Ground Zero" ;;
				xatrix) addon_name="The Reckoning" ;;
			esac

			make_wrapper "yquake2-${addon}" "yquake2 +set game ${addon}"
			make_desktop_entry "yquake2-${addon}" "Yamagi Quake II: ${addon_name}"
		fi
	done

	keepdir /usr/share/quake2

	einstalldocs
	if use client; then
		docinto examples
		dodoc stuff/cdripper.sh
	fi
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog
		elog "In order to play, you should do one of the following things:"
		elog " - install games-fps/quake2-data or games-fps/quake2-demodata;"
		elog " - manually copy game data files into ~/.yq2/ or"
		elog "   ${EROOT}/usr/share/quake2/."
		elog "Read ${EROOT}/usr/share/doc/${PF}/README.md* for more information."
		elog
	fi
}
