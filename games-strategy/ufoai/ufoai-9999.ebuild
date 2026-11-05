# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop flag-o-matic xdg

# 2.5.0 requires several patches
COMMIT="763173ed036ebbee32c2a7bf6aefa19748df89ff"

# Upstream ship game data as a separate tarball with only maj.min
DIST_VERSION=$(ver_cut 1-2)

# Install game data here
DATADIR="/usr/share/${PN}"

DESCRIPTION="UFO: Alien Invasion - X-COM inspired strategy game"
HOMEPAGE="https://ufoai.org/"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ufoaiorg/ufoai.git"
else
	# for prerelease versions we need to generate the data tarball (else game will die at runtime due to mismatch)
	# Configure w/ -DDISABLE_TOOLS=OFF -DDISABLE_UFO2MAP=OFF -DDISABLE_BASE_PACKAGES=OFF -DDISABLE_MAPS_COMPILE=OFF
	# cmake --build build-data --target pk3
	# MTIME="$(git log -1 --format=%ct HEAD)"
	# find build-data/base -maxdepth 1 -type f -name '*.pk3' -printf 'base/%f\0' | LC_ALL=C sort -z \
	#   | tar --null -T - --format=gnu --owner=portage --group=portage --mtime="@${MTIME}" \
	#       -C build-data -cf ufoai-2.6-data.tar
	SRC_URI="
		https://github.com/ufoaiorg/ufoai/archive/${COMMIT}.tar.gz -> ${PN}-${COMMIT}.tar.gz
		https://deps.gentoo.zip/games-strategy/ufoai/${PN}-${DIST_VERSION}-${COMMIT}-data.tar
	"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

# https://ufoai.org/licenses/
LICENSE="GPL-2 GPL-3 public-domain CC-BY-3.0 CC-BY-SA-3.0 MIT"
SLOT="0"

IUSE="+client cpu_flags_x86_sse debug server"
REQUIRED_USE="|| ( client server )"

RDEPEND="
	dev-lang/lua:5.3
	net-misc/curl
	virtual/zlib:=

	client? (
		dev-libs/mxml:4
		media-libs/libglvnd[X]
		media-libs/libjpeg-turbo:=
		media-libs/libogg
		media-libs/libpng:0=
		media-libs/libsdl2[joystick,opengl,sound,threads(+),video]
		media-libs/libvorbis
		media-libs/sdl2-mixer[vorbis]
		media-libs/sdl2-ttf
	)

	server? (
		media-libs/libsdl2[threads(+)]
	)
"

DEPEND="
	${RDEPEND}
	sys-devel/gettext
"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		unpack ${PN}-${COMMIT}.tar.gz
		cd "${S}" || die
		unpack ${PN}-${DIST_VERSION}-${COMMIT}-data.tar
	fi
}

src_configure() {
	# Avoid noise, will be present in 2.6
	append-cxxflags -Wno-expansion-to-defined
	if use cpu_flags_x86_sse; then
		append-cflags -msse
		append-cxxflags -msse
	fi
	append-cppflags "-DPKGDATADIR=\\\\\\\"${EPREFIX}${DATADIR}\\\\\\\""
	append-cppflags "-DPKGLIBDIR=\\\\\\\"${EPREFIX}${DATADIR}/base\\\\\\\""

	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=$(usex debug Debug RelWithDebInfo)
		-DDISABLE_BASE_PACKAGES=ON
		-DDISABLE_DOXYGEN_DOCS=ON
		-DDISABLE_MANUAL=ON
		-DDISABLE_MAPS_COMPILE=ON
		-DDISABLE_TESTS=ON
		-DDISABLE_TOOLS=ON
		-DDISABLE_UFO=$(usex client OFF ON)
		-DDISABLE_UFO2MAP=ON
		-DDISABLE_UFODED=$(usex server OFF ON)
		-DDISABLE_UFOMODEL=ON
		-DDISABLE_UFORADIANT=ON
	)

	# Would prefer USE prebuilt-assets to control this
	# but upstream exclude assets in their gitignore.
	if [[ ${PV} == 9999 ]]; then
		mycmakeargs+=(
			-DDISABLE_BASE_PACKAGES=OFF
			-DDISABLE_MAPS_COMPILE=OFF
			-DDISABLE_TOOLS=OFF
			-DDISABLE_UFO2MAP=OFF
		)
	fi

	if use client || use server; then
		mycmakeargs+=( -DDISABLE_GAME=OFF )
	else
		mycmakeargs+=( -DDISABLE_GAME=ON )
	fi

	cmake_src_configure
}

src_compile() {
	# lang is a required target for all translations (incl English?)
	cmake_src_compile all lang
	if [[ ${PV} == 9999 ]]; then
		cmake_src_compile pk3
	fi
}

src_install() {
	newicon -s 32 src/ports/linux/ufo.png ${PN}.png

	local base_pkgdir="${S}/base"
	if [[ ${PV} == 9999 ]]; then
		base_pkgdir="${BUILD_DIR}/base"
	fi

	insinto "${DATADIR}/base"
	doins "${base_pkgdir}"/*.pk3
	if [[ -d "${BUILD_DIR}/base/i18n" ]]; then
		doins -r "${BUILD_DIR}/base/i18n"
	fi
	exeinto "${DATADIR}/base"
	doexe "${BUILD_DIR}/base/game.so"

	if use client; then
		dobin "${BUILD_DIR}/ufo"
	fi

	if use server; then
		dobin "${BUILD_DIR}/ufoded"
	fi

	if use client; then
		doman debian/ufo.6
		make_desktop_entry ufo "UFO: Alien Invasion" ${PN}
	fi

	if use server; then
		doman debian/ufoded.6
		make_desktop_entry ufoded "UFO: Alien Invasion Server" ${PN} "Game;StrategyGame" "Terminal=true"
	fi
}
