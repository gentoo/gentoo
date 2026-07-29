# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

COMMIT="094b94dc"
DESCRIPTION="Modern build of the Unreal Tournament 2004 engine"
HOMEPAGE="https://github.com/OldUnreal/UT2004Patches"
SRC_URI="
	https://github.com/OldUnreal/UT2004Patches/releases/download/${PV/_pre/-preview-}/OldUnreal-UT2004Patch${PV%_*}-Linux-${COMMIT}.tar.bz2
	mirror+https://dev.gentoo.org/~chewi/${PN}.png
"
S="${WORKDIR}"

LICENSE="Epic-TOS"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
IUSE="dedicated l10n_de l10n_es l10n_fr l10n_he l10n_it l10n_ko l10n_pl l10n_ru"
RESTRICT="bindist mirror strip"

UT_DEPEND="games-fps/ut2004-data-3369"

BDEPEND="
	dev-util/patchelf
"
RDEPEND="
	media-libs/libglvnd
	media-libs/libsdl3[opengl]
	media-libs/openal
	dedicated? ( acct-user/unreal )
	!games-fps/ut2004-bonuspack-ece
	!games-fps/ut2004-bonuspack-mega
	!games-server/ut2004-ded
	!<${UT_DEPEND}
"
PDEPEND="
	>=${UT_DEPEND}
"

DIR="/opt/${PN}"
QA_PREBUILT="*"

declare -A SYSTEMS=(
	[amd64]=""
	[arm64]="ARM64"
	[ppc64]="PPC64LE"
)

System="System${SYSTEMS[${ARCH}]}"

src_prepare() {
	default

	# https://github.com/OldUnreal/FullGameInstallers/issues/93
	ln -s ../System/{CacheRecords.ucl,Packages.md5,xaplayersl3.upl,xplayersL{1,2}.upl} SystemARM64/ || die

	# https://github.com/OldUnreal/UT2004Patches/issues/508
	patchelf --remove-needed libGLX.so.0 "${System}"/{Anti,OpenGL}Drv.so || die

	# This shouldn't be executable.
	chmod a-x System/CacheRecords.ucl || die

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
	rm -v "${System}"/lib{openal,SDL3}.so* || die

	# Make it easier to generate cache files in other ebuilds.
	mkdir -p Gentoo/System || die
	touch Gentoo/UT2K4MOD.ini || die
	patch -p0 -o - "${System}"/Default.ini "${FILESDIR}"/gentoo-mod.patch > Gentoo/System/Gentoo.ini || die

	# Drop unwanted localisation files.
	local dir lang
	for dir in SystemLocalized/*; do
		lang=${dir#*/}
		lang=${lang:0:2}
		[[ ${lang} == in ]] && continue
		use "l10n_${lang}" || rm -rv "${dir}" || die
	done
}

src_install() {
	dodir "${DIR}"
	cp -rP * "${ED}${DIR}" || die

	sed -e "s:@EPREFIX@:${EPREFIX}:g" -e "s:@System@:${System}:g" "${FILESDIR}/wrapper.sh" | newbin - ${PN}
	dosym ${PN} /usr/bin/${PN}-ucc

	doicon -s 128 "${DISTDIR}/${PN}.png"
	make_desktop_entry --eapi9 ${PN} -n "Unreal Tournament 2004" \
		-C "Epic's popular first-person shooter"

	if use dedicated; then
		newconfd "${FILESDIR}"/${PN}-ded.confd ${PN}-ded
		newinitd "${FILESDIR}"/${PN}-ded.initd ${PN}-ded
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	# The CD key is no longer needed.
	rm -f "${EROOT}${DIR}"/System/cdkey || die
}
