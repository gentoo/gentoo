# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="cs fr ru sk uk zh_CN zh_TW"
inherit cmake plocale

DESCRIPTION="Console version of Stardict program"
HOMEPAGE="https://dushistov.github.io/sdcv/"
SRC_URI="https://github.com/Dushistov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="darkterm nls readline test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.36
	sys-libs/zlib
	readline? ( sys-libs/readline:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	nls? ( >=sys-devel/gettext-0.14.1 )
	test? ( app-misc/jq )
"

PATCHES=(
	"${FILESDIR}/${PN}-0.5.3-t_list.patch"
	"${FILESDIR}/${PN}-t_interactive.patch"
)

src_prepare() {
	if use darkterm; then
		sed -i 's/;34m/;36m/' src/libwrapper.cpp || die
	fi

	rm_loc() {
		rm "po/${1}.po" || die
	}
	plocale_for_each_disabled_locale rm_loc

	# do not install locale-specific man pages unless asked to
	if ! has uk ${LINGUAS-uk}; then
		sed -ni '/share\/man\/uk/!p' CMakeLists.txt || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_NLS="$(usex nls)"
		-DWITH_READLINE="$(usex readline)"
		-DBUILD_TESTS="$(usex test ON OFF)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use nls && cmake_src_compile lang
}

src_install() {
	# with USE=nls, but empty intersection of LINGUAS and list of
	# supported translations, this directory is required, see bug 583386
	mkdir -p "${BUILD_DIR}/locale"
	cmake_src_install
	dodoc doc/DICTFILE_FORMAT
}
