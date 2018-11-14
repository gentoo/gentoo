# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="cs fr ru sk uk zh_CN zh_TW"
: ${CMAKE_MAKEFILE_GENERATOR:="ninja"}

inherit cmake-utils l10n

DESCRIPTION="Console version of Stardict program"
HOMEPAGE="https://dushistov.github.io/sdcv/"
SRC_URI="https://github.com/Dushistov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="darkterm nls readline test"

RDEPEND="
	>=dev-libs/glib-2.6.1
	sys-libs/zlib
	readline? ( sys-libs/readline:= )
"
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.14.1 )
	test? ( app-misc/jq )
"

PATCHES=(
	"${FILESDIR}/${PN}-t_list.patch"
	"${FILESDIR}/${PN}-t_interactive.patch"
)

src_prepare() {
	if use darkterm; then
		sed -i 's/;34m/;36m/' src/libwrapper.cpp || die
	fi

	rm_loc() {
		rm "po/${1}.po" || die
	}
	l10n_for_each_disabled_locale_do rm_loc

	# do not install locale-specific man pages unless asked to
	if ! has uk ${LINGUAS-uk}; then
		sed -ni '/share\/man\/uk/!p' CMakeLists.txt || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_NLS="$(usex nls)"
		-DWITH_READLINE="$(usex readline)"
		-DBUILD_TESTS="$(usex test ON OFF)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use nls && cmake-utils_src_compile lang
}

src_install() {
	# with USE=nls, but empty intersection of LINGUAS and list of
	# supported translations, this directory is required, see bug 583386
	mkdir -p "${BUILD_DIR}/locale"
	cmake-utils_src_install
	dodoc doc/DICTFILE_FORMAT
}
