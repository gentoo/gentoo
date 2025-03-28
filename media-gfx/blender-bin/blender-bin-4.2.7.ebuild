# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg-utils

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"

LICENSE="GPL-3+ Apache-2.0"
SLOT="$(ver_cut 1-2)"

if [[ ${PV} == *9999* ]] ; then
	# BLENDER_BIN_URL can be used to point to the url of an upstream release archive.
	PROPERTIES="live"
else
	SRC_URI="
		https://download.blender.org/release/Blender${SLOT}/blender-${PV}-linux-x64.tar.xz
	"
	KEYWORDS="~amd64"
fi

IUSE="cuda hip oneapi"
RESTRICT="strip test"

QA_PREBUILT="opt/${P}/*"

if [[ ${PV} == *9999* ]] ; then
	BDEPEND="
		app-misc/jq
	"
fi

# no := here, this is prebuilt
RDEPEND="
	app-arch/zstd
	media-libs/libglvnd[X]
	sys-apps/util-linux
	sys-libs/glibc
	sys-libs/ncurses
	sys-libs/zlib
	virtual/libcrypt
	x11-base/xorg-server
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libXxf86vm
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	cuda? (
		x11-drivers/nvidia-drivers
	)
	hip? (
		>=dev-util/hip-6
	)
	oneapi? (
		dev-libs/level-zero
	)
"

src_unpack() {
	local my_A
	if [[ ${PV} == *9999* ]] ; then
		local file_name url
		if [[ -n "${BLENDER_BIN_URL}" ]]; then
			einfo "Using ${BLENDER_BIN_URL} as SRC_URI. You are on your own."
			file_name="$(basename "${BLENDER_BIN_URL}")"
			url="${BLENDER_BIN_URL}"
		else
			wget "https://builder.blender.org/download/daily/?format=json&v=2" -O "${T}/release.json" \
				|| die "failed to retrieve release.json"

			local branch commit rel_json release_cycle version
			rel_json=$(
				jq -r 'map(select(.platform == "linux" and .branch == "'"${EGIT_BRANCH:-main}"'" and .file_extension == "xz"))
					| .[0]' \
					"${T}/release.json"
			)
			branch=$( echo "${rel_json}" | jq -r '.branch' )
			commit=$( echo "${rel_json}" | jq -r '.hash' )
			file_name=$( echo "${rel_json}" | jq -r '.file_name' )
			release_cycle=$( echo "${rel_json}" | jq -r '.release_cycle' )
			url=$( echo "${rel_json}" | jq -r '.url' )
			version=$( echo "${rel_json}" | jq -r '.version' )

			einfo "Fetching blender-${version}-${release_cycle}-${branch}-${commit}"
			einfo "            url: ${url}"
			einfo "        version: ${version}"
			einfo "  release_cycle: ${release_cycle}"
			einfo "         branch: ${branch}"
			einfo "         commit: ${commit}"
			einfo
		fi

		wget -c "${url}"{,.sha256} -P "${T}" || die "failed to fetch ${url}"

		my_A="${T}/${file_name}"

		# Check sha256sum
		local sha256sum_exp sha256sum_is
		sha256sum_exp="$(cat "${T}/${file_name}.sha256")"
		sha256sum_is="$(sha256sum "${T}/${file_name}" | cut -d ' ' -f 1)"
		if [[ "${sha256sum_exp}" != "${sha256sum_is}" ]]; then
			eerror "sha256sum mismatch for ${file_name}"
			eerror "  expected ${sha256sum_exp}"
			eerror "  found    ${sha256sum_is}"
			die "sha256sum mismatch"
		fi
	else
		my_A="${DISTDIR}/blender-${PV}-linux-x64.tar.xz"
	fi

	unpack "${my_A}"

	local dirs
	dirs="$(find "${WORKDIR}" -mindepth 1 -maxdepth 1 | wc -l)"
	if [[ "${dirs}" -ne 1 ]]; then
		die "unpack resulted in ${dirs} dirs in ${WORKDIR}"
	fi

	mv "${WORKDIR}"/* "${S}" || die "mv"
}

src_prepare() {
	default

	# Remove unused gpu libraries so we don't get missing libraries from QA
	if ! use cuda; then
		rm \
			lib/libOpenImageDenoise_device_cuda* \
			|| eqawarn "failed cleaning cuda"
	fi

	if ! use hip; then
		rm \
			lib/libOpenImageDenoise_device_hip* \
			|| eqawarn "failed cleaning hip"
	fi

	if ! use oneapi; then
		rm \
			lib/libOpenImageDenoise_device_sycl* \
			lib/libpi_level_zero* \
			|| eqawarn "failed cleaning oneapi"
	fi

	# Prepare icons and .desktop for menu entry
	mv blender.desktop "${P}.desktop" || die
	mv blender.svg "${P}.svg" || die
	mv blender-symbolic.svg "${P}-symbolic.svg" || die

	# X-KDE-RunOnDiscreteGpu is obsolete, so trim it
	sed \
		-e "s/=blender/=${P}/" \
		-e "s/Name=Blender/Name=Blender Bin ${PV}/" \
		-e "/X-KDE-RunOnDiscreteGpu.*/d" \
		-i "${P}.desktop" || die
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	# We could use the version from the release.json instead of PN here
	local BLENDER_OPT_HOME="/opt/${P}"

	# Install icons and .desktop for menu entry
	doicon -s scalable "${S}"/blender*.svg
	domenu "${P}.desktop"

	# Install all the blender files in /opt
	dodir "${BLENDER_OPT_HOME%/*}"
	mv "${S}" "${ED}${BLENDER_OPT_HOME}" || die

	# Create symlink /usr/bin/blender-bin
	dodir "/usr/bin"
	dosym -r "${BLENDER_OPT_HOME}/blender" "/usr/bin/${P}"
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
