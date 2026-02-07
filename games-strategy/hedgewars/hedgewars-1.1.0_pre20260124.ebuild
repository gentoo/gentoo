# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR=emake
LUA_COMPAT=( lua5-1 )
RUST_MIN_VER="1.87.0"

inherit cargo cmake lua-single xdg-utils

MY_P=${PN}-src-${PV}
EGIT_COMMIT="1bbc396d3123702ee9445c5c6bdafdfa6d43d327"

DESCRIPTION="A turn-based strategy, artillery, action and comedy game"
HOMEPAGE="https://www.hedgewars.org/"
if [[ -n ${EGIT_COMMIT} ]]; then
	SRC_URI="https://github.com/${PN}/hw/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/hw-${EGIT_COMMIT}
else
	SRC_URI="https://www.hedgewars.org/download/releases/${MY_P}.tar.bz2"
	S="${WORKDIR}"/${MY_P}
fi
SRC_URI+=" https://github.com/puleglot/hw/releases/download/${PV}/${P}-crates.tar.xz"

LICENSE="GPL-2 Apache-2.0 FDL-1.3"
# Dependent crate licenses
LICENSE+="
	MIT Unicode-3.0
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ffmpeg"

REQUIRED_USE="${LUA_REQUIRED_USE}"

QA_FLAGS_IGNORED="/usr/bin/hwengine" # pascal sucks
QA_PRESTRIPPED="/usr/bin/hwengine" # pascal sucks

DEPEND="${LUA_DEPS}
	>=dev-games/physfs-3.0.1
	dev-qt/qtbase:6[network,widgets]
	media-libs/libpng:0=
	media-libs/libsdl2:=[opengl]
	media-libs/sdl2-image:=[png]
	media-libs/sdl2-mixer:=[vorbis]
	media-libs/sdl2-net:=
	media-libs/sdl2-ttf:=
	virtual/zlib:=
	ffmpeg? ( media-video/ffmpeg:= )
	"
RDEPEND="${DEPEND}
	app-arch/xz-utils
	>=media-fonts/dejavu-2.28
	media-fonts/wqy-zenhei"
BDEPEND="
	dev-qt/qttools:6
	dev-lang/fpc
	"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-cmake_lua_version.patch"
	# Prevent fallback to pas2c on 32 bit arches
	"${FILESDIR}/${PN}-1.0.2-respect-cc.patch"
	"${FILESDIR}/${PN}-1.1.0-no-qt-deploy.patch"
)

src_prepare() {
	if [[ -n ${EGIT_COMMIT} ]]; then
		cat <<-EOF > share/version_info.txt || die
			Hedgewars versioning information, do not modify
			rev GIT
			hash ${EGIT_COMMIT}
		EOF
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_ENGINE_C=OFF
		-DBUILD_OFFLINE=ON
		-DMINIMAL_FLAGS=ON
		-DNOSERVER=ON
		-DDATA_INSTALL_DIR="${EPREFIX}/usr/share/${PN}"
		-Dtarget_binary_install_dir="${EPREFIX}/usr/bin"
		-Dtarget_library_install_dir="${EPREFIX}/usr/$(get_libdir)"
		-DCMAKE_VERBOSE_MAKEFILE=TRUE
		# Need to tell the build system where the fonts are located
		# as it uses PhysFS' symbolic link protection mode which
		# prevents us from symlinking the fonts into the right directory
		#   https://hg.hedgewars.org/hedgewars/rev/76ad55807c24
		#   https://icculus.org/physfs/docs/html/physfs_8h.html#aad451d9b3f46f627a1be8caee2eef9b7
		-DFONTS_DIRS="${EPREFIX}/usr/share/fonts/wqy-zenhei;${EPREFIX}/usr/share/fonts/dejavu"
		# upstream sets RPATH that leads to weird breakage
		# https://bugzilla.redhat.com/show_bug.cgi?id=1200193
		-DCMAKE_SKIP_RPATH=ON
		-DLUA_VERSION=$(lua_get_version)
		-DNOVIDEOREC=$(usex ffmpeg OFF ON)
	)

	CMAKE_BUILD_TYPE=$(usex debug Debug)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	doman man/${PN}.6

	rm -f "${ED}"/usr/bin/hwengine_future_install_target.cmake || die
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
