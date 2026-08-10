# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Modern build of the original Unreal engine"
HOMEPAGE="https://www.oldunreal.com/downloads/unreal/oldunreal-patches/"
SRC_URI="
	https://github.com/OldUnreal/Unreal-testing/releases/download/v${PV/_p/_}/OldUnreal-UnrealPatch${PV%_p*}-Linux.tar.bz2
	mirror+https://dev.gentoo.org/~chewi/distfiles/${PN}.png
"
S="${WORKDIR}"

LICENSE="Epic-TOS Apache-2.0 BSD BSD-2 HappyBunny libpng2 MIT OFL-1.1 ZLIB" # See LICENSE.md
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64 ~x86"
IUSE="dedicated l10n_ca l10n_de l10n_el l10n_es l10n_fr l10n_it l10n_nl l10n_pl l10n_pt l10n_ru opengl"
RESTRICT="bindist mirror strip"

UT_DEPEND="games-fps/unreal-gold-data-226b"

BDEPEND="
	dev-util/patchelf
"
RDEPEND="
	media-libs/libglvnd
	media-libs/libsdl3[opengl]
	media-libs/libsndfile
	media-libs/libxmp
	media-libs/openal
	media-libs/sdl3-ttf
	media-sound/mpg123-base
	dedicated? ( acct-user/unreal )
"
PDEPEND="
	>=${UT_DEPEND}
"

DIR="/opt/${PN}"
QA_PREBUILT="*"

declare -gA SYSTEMS=(
	[amd64]="64"
	[arm64]="ARM64"
	[x86]=""
)

src_prepare() {
	declare -g System="System${SYSTEMS[${ARCH}]}"
	default

	# Fix NEEDED entry for libmpg123.
	# https://github.com/OldUnreal/UnrealTournamentPatches/issues/2053
	patchelf --replace-needed libmpg123.so{,.0} "${System}"/ALAudio.so || die

	# These shouldn't be executable.
	chmod a-x System/*.u || die

	if use arm64; then
		# The .ini files are missing for arm64.
		# https://github.com/OldUnreal/Unreal-testing/issues/451
		sed "s:System64:SystemARM64:g" System64/DefaultLinux.ini > SystemARM64/DefaultLinux.ini || die
		mv -v System64/DefUser.ini SystemARM64/ || die
	fi

	# Remove the non-native files. The main System directory is shared, it's not
	# just for amd64, so we cannot delete it entirely.
	local system
	for system in "${!SYSTEMS[@]}"; do
		if [[ ${system} != ${ARCH} ]]; then
			if [[ -n ${SYSTEMS[${system}]} ]]; then
				rm -rv "System${SYSTEMS[${system}]}/" || die
			else
				find System/ ! -type d \( -type l -o -executable -o -name "*.ini" -o -name "*.so*" \) | xargs rm -v -- || die
			fi
		fi
	done

	# Remove bundled libraries.
	rm -v "${System}"/lib{mpg123,openal,SDL3*,sndfile,xmp}.so* || die

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

src_install() {
	insinto "${DIR}"
	doins -r */

	local exes=( "${System}"/{*-bin-*,*.so*} )
	fperms a+x "${exes[@]/#/${DIR}/}"

	sed \
		-e "s:@EPREFIX@:${EPREFIX}:g" \
		-e "s:@System@:${System}:g" \
		"${FILESDIR}/wrapper.sh" | newbin - ${PN}

	dosym ${PN} /usr/bin/${PN}-ucc
	dosym ${PN}-bin-${ARCH} "${DIR}/${System}/${PN}-bin"
	dosym ucc-bin-${ARCH} "${DIR}/${System}/ucc-bin"

	doicon -s 128 "${DISTDIR}/${PN}.png"
	make_desktop_entry --eapi9 ${PN} -n "Unreal" \
		-C "Epic's popular first-person shooter"

	if use dedicated; then
		newconfd "${FILESDIR}"/${PN}-ded.confd ${PN}-ded
		newinitd "${FILESDIR}"/${PN}-ded.initd ${PN}-ded
	fi
}
