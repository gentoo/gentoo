# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Modern build of the Unreal Tournament (99) engine"
HOMEPAGE="https://www.oldunreal.com/downloads/unrealtournament/oldunreal-patches-for-unrealtournament-version-469/"
SRC_URI="
	amd64? ( https://github.com/OldUnreal/UnrealTournamentPatches/releases/download/v${PV//_/-}/OldUnreal-UTPatch${PV%_*}-Linux-amd64.tar.bz2 )
	arm64? ( https://github.com/OldUnreal/UnrealTournamentPatches/releases/download/v${PV//_/-}/OldUnreal-UTPatch${PV%_*}-Linux-arm64.tar.bz2 )
	x86? ( https://github.com/OldUnreal/UnrealTournamentPatches/releases/download/v${PV//_/-}/OldUnreal-UTPatch${PV%_*}-Linux-x86.tar.bz2 )
	mirror+https://dev.gentoo.org/~chewi/distfiles/${PN}.png
"
S="${WORKDIR}"

LICENSE="Epic-TOS Apache-2.0 BSD BSD-2 HappyBunny libpng2 MIT OFL-1.1 ZLIB" # See LICENSE.md
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64 ~x86"
IUSE="dedicated l10n_ca l10n_de l10n_el l10n_es l10n_fr l10n_it l10n_nl l10n_pt l10n_ru opengl vulkan video_cards_lima video_cards_panfrost"
RESTRICT="bindist mirror strip"

UT_DEPEND="games-fps/unreal-tournament-data-436_p4"

BDEPEND="
	dev-util/patchelf
"
RDEPEND="
	media-libs/libsdl3[opengl?,vulkan?]
	media-libs/libsndfile
	media-libs/libxmp
	media-libs/openal
	media-libs/sdl3-ttf
	media-sound/mpg123-base
	dedicated? ( acct-user/unreal )
	opengl? ( media-libs/libglvnd )
	vulkan? ( media-libs/vulkan-loader )
"
PDEPEND="
	>=${UT_DEPEND}
"

DIR="/opt/${PN}"
QA_PREBUILT="*"

src_prepare() {
	declare -g System="System"
	default

	# Fix NEEDED entry for libmpg123.
	# https://github.com/OldUnreal/UnrealTournamentPatches/issues/2053
	patchelf --replace-needed libmpg123.so{,.0} "${System}"/ALAudio.so || die

	# Remove bundled libraries. LAME doesn't seem to be used.
	rm -v "${System}"/lib{mp3lame,mpg123,openal,SDL3*,sndfile,xmp}.so* || die

	# This audio driver requires libfmod, which is missing on amd64 and arm64.
	if ! use x86; then rm -v "${System}"/Cluster.so || die; fi

	# Make WASD work out of the box.
	patch -p0 "${System}"/DefUser.ini "${FILESDIR}"/${PN}-wasd.patch || die

	# Drop unwanted localisation files.
	local dir lang
	for dir in SystemLocalized/*; do
		lang=${dir#*/}
		lang=${lang:0:2}
		[[ ${lang} == in ]] && continue
		[[ ${lang} == ct ]] && lang=ca # Catalan
		use "l10n_${lang}" || rm -rv "${dir}" || die
	done
}

src_configure() {
	if use vulkan; then
		declare -g GameRenderDevice="VulkanDrv.VulkanRenderDevice"
	elif use opengl; then
		# XOpenGLDrv rendering is broken on Panfrost and probably Lima.
		# https://github.com/OldUnreal/UnrealTournamentPatches/issues/2107
		if use video_cards_lima || use video_cards_panfrost; then
			declare -g GameRenderDevice="OpenGLDrv.OpenGLRenderDevice"
		else
			declare -g GameRenderDevice="XOpenGLDrv.XOpenGLRenderDevice"
		fi
	else
		unset GameRenderDevice
	fi

	if [[ -n ${GameRenderDevice} ]]; then
		einfo "Enforcing the ${GameRenderDevice} renderer."
	else
		einfo "Not enforcing the renderer. Change the USE flags to enforce it."
	fi
}

src_install() {
	insinto "${DIR}"
	doins -r */

	local exes=( "${System}"/{*-bin,*.so*} )
	fperms a+x "${exes[@]/#/${DIR}/}"

	sed \
		-e "s:@EPREFIX@:${EPREFIX}:g" \
		-e "s:@System@:${System}:g" \
		-e "s:@GameRenderDevice@:${GameRenderDevice}:g" \
		"${FILESDIR}/wrapper.sh" | newbin - ${PN}

	# ucc does not benefit from the wrapper.
	dosym -r "${DIR}/${System}"/ucc-bin /usr/bin/${PN}-ucc

	doicon -s 128 "${DISTDIR}/${PN}.png"
	make_desktop_entry --eapi9 ${PN} -n "Unreal Tournament" \
		-C "Epic's popular first-person shooter"

	if use dedicated; then
		newconfd "${FILESDIR}"/${PN}-ded.confd ${PN}-ded
		newinitd "${FILESDIR}"/${PN}-ded.initd ${PN}-ded
	fi

	dodoc ReleaseNotes.md
}
