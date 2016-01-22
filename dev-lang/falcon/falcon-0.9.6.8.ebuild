# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cmake-utils multilib

MY_P="${P/f/F}"

DESCRIPTION="An open source general purpose untyped language written in C++"
HOMEPAGE="http://falconpl.org/"
SRC_URI="http://falconpl.org/project_dl/_official_rel/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl dbus debug gd gtk mysql pdf readline sdl sqlite"

DEPEND="
	dev-libs/libpcre
	sys-libs/zlib
	curl? ( net-misc/curl )
	dbus? ( sys-apps/dbus )
	gd? ( media-libs/gd:= )
	gtk? ( dev-libs/glib:2 )
	mysql? ( virtual/libmysqlclient:= )
	readline? ( sys-libs/readline:0 )
	pdf? ( media-libs/libharu )
	sdl? (
		media-libs/libsdl
		media-libs/sdl-image
		media-libs/sdl-mixer
		media-libs/sdl-ttf
	)
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS ChangeLog README RELNOTES"
PATCHES=(
	"${FILESDIR}/${P}-mongo-amd64.patch"
	"${FILESDIR}/${P}-mongo-stdint.patch"
)

src_configure() {
	local mycmakeargs=(
		-DFALCON_BUILD_CURL=$(usex curl)
		-DFALCON_BUILD_DBUS=$(usex dbus)
		-DFALCON_BUILD_GD2=$(usex gd)
		-DFALCON_BUILD_GTK=$(usex gtk)
		-DFALCON_BUILD_PDF=$(usex pdf)
		-DFALCON_BUILD_SDL=$(usex sdl)
		-DFALCON_DBI_BUILD_MYSQL=$(usex mysql)
		-DFALCON_DBI_BUILD_SQLITE=$(usex sqlite)
		-DFALCON_DISABLE_RPATH=ON
		-DFALCON_SKIP_BISON=ON
		-DFALCON_WITH_EDITLINE=$(usex readline)
		-DFALCON_WITH_MANPAGES=ON
		-DFALCON_WITH_INTERNAL_EDITLINE=OFF
		-DFALCON_WITH_INTERNAL_PCRE=OFF
		-DFALCON_WITH_INTERNAL_ZLIB=OFF
		-DFALCON_WITH_GPL_READLINE=ON
	)
	cmake-utils_src_configure
}

src_test() {
	pushd "${S}/tests/core/testsuite" > /dev/null || die
	"${CMAKE_BUILD_DIR}/bin/faltest"
	popd > /dev/null || die
}
