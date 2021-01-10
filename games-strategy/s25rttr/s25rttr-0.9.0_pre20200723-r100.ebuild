# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} )

inherit desktop flag-o-matic lua-single toolchain-funcs xdg cmake

DESCRIPTION="Open source remake of The Settlers II: Gold Edition (needs original data files)"
HOMEPAGE="https://www.siedler25.org/"

# To generate from git repo:
# echo -e "COMMIT=\"$(git rev-parse HEAD)\"\nSRC_URI=\"\n\thttps://github.com/Return-To-The-Roots/s25client/archive/\${COMMIT}.tar.gz -> s25client-\${COMMIT}.tar.gz" && git submodule --quiet foreach --recursive 'url=$(git remote get-url origin); gh=${url#*github.com[:/]}; gh=${gh%.git}; echo -e "\thttps://github.com/${gh}/archive/${sha1}.tar.gz -> \${PN}-${gh##*/}-${sha1}.tar.gz"' | egrep -v "/(dev-tools|libsamplerate|s25update)/" | sort && echo '"'
COMMIT="f0b97b120140c96bbeacae9c22633f899931db69"
SRC_URI="
	https://github.com/Return-To-The-Roots/s25client/archive/${COMMIT}.tar.gz -> s25client-${COMMIT}.tar.gz
	https://github.com/mat007/turtle/archive/9dcdcf9061b929a03f188531ea5cbd530b6234ab.tar.gz -> ${PN}-turtle-9dcdcf9061b929a03f188531ea5cbd530b6234ab.tar.gz
	https://github.com/Return-To-The-Roots/languages/archive/6906b7ce9cb64242ba406eda34a404fa8eb1e33d.tar.gz -> ${PN}-languages-6906b7ce9cb64242ba406eda34a404fa8eb1e33d.tar.gz
	https://github.com/Return-To-The-Roots/libendian/archive/dd2c11498f679247530b6b7cf7bd5964f539ddfd.tar.gz -> ${PN}-libendian-dd2c11498f679247530b6b7cf7bd5964f539ddfd.tar.gz
	https://github.com/Return-To-The-Roots/liblobby/archive/9275cbfa2303cc8235e96f275829be0d84efd3a4.tar.gz -> ${PN}-liblobby-9275cbfa2303cc8235e96f275829be0d84efd3a4.tar.gz
	https://github.com/Return-To-The-Roots/libsiedler2/archive/5cb9993a32504337c63fd894266991445e0dcd65.tar.gz -> ${PN}-libsiedler2-5cb9993a32504337c63fd894266991445e0dcd65.tar.gz
	https://github.com/Return-To-The-Roots/libutil/archive/6c2ee0fa897541ea766533e03ebd53344908cf16.tar.gz -> ${PN}-libutil-6c2ee0fa897541ea766533e03ebd53344908cf16.tar.gz
	https://github.com/Return-To-The-Roots/mygettext/archive/b2fc5db651542a7fcc069223904f7debc27ec235.tar.gz -> ${PN}-mygettext-b2fc5db651542a7fcc069223904f7debc27ec235.tar.gz
	https://github.com/Return-To-The-Roots/s25edit/archive/677e4b39eaa7f6ecb701e7b50637a0f05fc691db.tar.gz -> ${PN}-s25edit-677e4b39eaa7f6ecb701e7b50637a0f05fc691db.tar.gz
	https://github.com/Return-To-The-Roots/s25maps/archive/5efbd103b19335828cab6e757224e87456c4a1e4.tar.gz -> ${PN}-s25maps-5efbd103b19335828cab6e757224e87456c4a1e4.tar.gz
	https://github.com/satoren/kaguya/archive/38ca7e1d894c138e454bbe5c89048bdd5091545a.tar.gz -> ${PN}-kaguya-38ca7e1d894c138e454bbe5c89048bdd5091545a.tar.gz
"

LICENSE="GPL-2+ GPL-3 Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}
	app-arch/bzip2
	>=dev-libs/boost-1.73:0=[nls]
	>=media-libs/libsamplerate-0.1.9
	>=media-libs/libsdl2-2.0.10-r2[opengl,sound,video]
	media-libs/libsndfile
	media-libs/sdl2-mixer[vorbis,wav]
	net-libs/miniupnpc
	virtual/opengl
"

DEPEND="
	${RDEPEND}
	test? ( >=sys-devel/clang-5 )
"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.0_pre20200723-cmake_lua_version.patch
)

S="${WORKDIR}/s25client-${COMMIT}"

# Build type is checked but blank is valid.
CMAKE_BUILD_TYPE=

src_unpack() {
	default

	local SRC DST
	for SRC in */; do
		case "${SRC}" in
			s25client-*)
				continue ;;
			s25maps-*)
				DST=data/RTTR/MAPS ;;
			*)
				DST=${SRC%-*}
				DST=external/${DST,,} ;;
		esac

		rmdir "${S}/${DST}" || die
		mv "${SRC}" "${S}/${DST}" || die
	done
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DCCACHE_PROGRAM=OFF
		-DCMAKE_SKIP_RPATH=ON
		-DRTTR_BUILD_UPDATER=OFF
		-DRTTR_ENABLE_OPTIMIZATIONS=OFF
		-DRTTR_ENABLE_SANITIZERS=$(usex test)
		-DRTTR_INCLUDE_DEVTOOLS=OFF
		-DRTTR_LIBDIR="$(get_libdir)/${PN}"
		-DRTTR_REVISION="${COMMIT}"
		-DRTTR_USE_SYSTEM_LIBSAMPLERATE=ON
		-DRTTR_VERSION="${PV##*_pre}" # Tests expect a date.
		-DLUA_VERSION=$(lua_get_version)
	)

	if use test && tc-is-gcc; then
		# Work around libasan and libsandbox both wanting to be first.
		append-ldflags -static-libasan
	fi

	cmake_src_configure
}

src_test() {
	SDL_AUDIODRIVER=dummy \
	SDL_VIDEODRIVER=dummy \
	cmake_src_test
}

src_install() {
	cmake_src_install

	doicon -s 64 tools/release/debian/s25rttr.png
	make_desktop_entry s25client "Return to the Roots"
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! has_version -r games-strategy/settlers-2-gold-data; then
		elog "Install games-strategy/settlers-2-gold-data or manually copy the DATA"
		elog "and GFX directories from original data files into"
		elog "${EPREFIX}/usr/share/${PN}/S2."
	fi
}
