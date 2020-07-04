# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic toolchain-funcs xdg cmake

DESCRIPTION="Open source remake of The Settlers II: Gold Edition (needs original data files)"
HOMEPAGE="https://www.siedler25.org/"

# To generate from git repo:
# echo -e "COMMIT=\"$(git rev-parse HEAD)\"\nSRC_URI=\"\n\thttps://github.com/Return-To-The-Roots/s25client/archive/\${COMMIT}.tar.gz -> s25client-\${COMMIT}.tar.gz" && git submodule --quiet foreach --recursive 'url=$(git remote get-url origin); gh=${url#*github.com[:/]}; gh=${gh%.git}; echo -e "\thttps://github.com/${gh}/archive/${sha1}.tar.gz -> \${PN}-${gh##*/}-${sha1}.tar.gz"' | egrep -v "/(dev-tools|libsamplerate|s25update)/" | sort && echo '"'
COMMIT="784eb58fc1eb42751042d82f16cc92617fc6c2ae"
SRC_URI="
	https://github.com/Return-To-The-Roots/s25client/archive/${COMMIT}.tar.gz -> s25client-${COMMIT}.tar.gz
	https://github.com/mat007/turtle/archive/5f8421b1d270665347280d4cab1caf159d6858de.tar.gz -> ${PN}-turtle-5f8421b1d270665347280d4cab1caf159d6858de.tar.gz
	https://github.com/Return-To-The-Roots/languages/archive/b1978170473bbf39a24254814e1b1f967a51ef4c.tar.gz -> ${PN}-languages-b1978170473bbf39a24254814e1b1f967a51ef4c.tar.gz
	https://github.com/Return-To-The-Roots/libendian/archive/dd2c11498f679247530b6b7cf7bd5964f539ddfd.tar.gz -> ${PN}-libendian-dd2c11498f679247530b6b7cf7bd5964f539ddfd.tar.gz
	https://github.com/Return-To-The-Roots/liblobby/archive/7d85ec40f03af619a6734f20edb28d991b3d61f2.tar.gz -> ${PN}-liblobby-7d85ec40f03af619a6734f20edb28d991b3d61f2.tar.gz
	https://github.com/Return-To-The-Roots/libsiedler2/archive/800d58ea072c35d3cf9832d2f6a5cdae92fc0445.tar.gz -> ${PN}-libsiedler2-800d58ea072c35d3cf9832d2f6a5cdae92fc0445.tar.gz
	https://github.com/Return-To-The-Roots/libutil/archive/c91488e4d2f0079a864c4be80eaba24a871e9772.tar.gz -> ${PN}-libutil-c91488e4d2f0079a864c4be80eaba24a871e9772.tar.gz
	https://github.com/Return-To-The-Roots/mygettext/archive/7e46bbb3e24891348f5629887efb0173690e83b8.tar.gz -> ${PN}-mygettext-7e46bbb3e24891348f5629887efb0173690e83b8.tar.gz
	https://github.com/Return-To-The-Roots/s25edit/archive/04b5e725036a0568e8da15447167c240563dbaba.tar.gz -> ${PN}-s25edit-04b5e725036a0568e8da15447167c240563dbaba.tar.gz
	https://github.com/Return-To-The-Roots/s25maps/archive/11a5f3e95405b7cf8088641efb4939eba9639cbc.tar.gz -> ${PN}-s25maps-11a5f3e95405b7cf8088641efb4939eba9639cbc.tar.gz
	https://github.com/satoren/kaguya/archive/38ca7e1d894c138e454bbe5c89048bdd5091545a.tar.gz -> ${PN}-kaguya-38ca7e1d894c138e454bbe5c89048bdd5091545a.tar.gz
"

LICENSE="GPL-2+ GPL-3 Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/bzip2
	>=dev-lang/lua-5.1:=
	>=dev-libs/boost-1.64:0=[nls]
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

S="${WORKDIR}/s25client-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/${PN}-loosen-libs.patch
)

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
		-DRTTR_USE_SYSTEM_SAMPLERATE=ON
		-DRTTR_VERSION="${PV}"
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
