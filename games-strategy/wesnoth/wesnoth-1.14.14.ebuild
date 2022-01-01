# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic toolchain-funcs xdg

DESCRIPTION="Battle for Wesnoth - A fantasy turn-based strategy game"
HOMEPAGE="http://www.wesnoth.org
	https://github.com/wesnoth/wesnoth"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
# uneven minor versions are development versions
if [[ $(( $(ver_cut 2) % 2 )) == 0 ]] ; then
	KEYWORDS="~amd64 ~x86"
fi
IUSE="dbus dedicated doc fribidi libressl nls server"

RDEPEND="
	acct-group/wesnoth
	acct-user/wesnoth
	>=dev-libs/boost-1.50:=[nls,threads,icu]
	>=media-libs/libsdl2-2.0.4:0[joystick,video,X]
	!dedicated? (
		dev-libs/glib:2
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
		>=media-libs/fontconfig-2.4.1
		>=media-libs/sdl2-image-2.0.0[jpeg,png]
		>=media-libs/sdl2-mixer-2.0.0[vorbis]
		>=media-libs/sdl2-ttf-2.0.12
		media-libs/libvorbis
		>=x11-libs/pango-1.22.0
		>=x11-libs/cairo-1.10.0
		sys-libs/readline:0=
		dbus? ( sys-apps/dbus )
		fribidi? ( dev-libs/fribidi )
	)"
DEPEND="${RDEPEND}
	x11-libs/libX11
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/wesnoth-1.14.14-ar.patch"
)

src_prepare() {
	cmake_src_prepare

	if ! use doc ; then
		sed -i \
			-e '/manual/d' \
			doc/CMakeLists.txt || die
	fi

	# respect LINGUAS (bug #483316)
	if [[ ${LINGUAS+set} ]] ; then
		local lang langs=()
		for lang in $(cat po/LINGUAS) ; do
			has ${lang} ${LINGUAS} && langs+=( ${lang} )
		done
		echo "${langs[@]}" > po/LINGUAS || die
	fi
}

src_configure() {
	filter-flags -ftracer -fomit-frame-pointer
	if [[ $(gcc-major-version) -eq 3 ]] ; then
		filter-flags -fstack-protector
		append-flags -fno-stack-protector
	fi

	if use dedicated || use server ; then
		mycmakeargs=(
			-DENABLE_CAMPAIGN_SERVER="ON"
			-DENABLE_SERVER="ON"
			-DSERVER_UID="${PN}"
			-DSERVER_GID="${PN}"
			-DFIFO_DIR="/run/wesnothd"
			)
	else
		mycmakeargs=(
			-DENABLE_CAMPAIGN_SERVER="OFF"
			-DENABLE_SERVER="OFF"
			)
	fi
	mycmakeargs+=(
		-Wno-dev
		-DENABLE_GAME="$(usex !dedicated)"
		-DENABLE_DESKTOP_ENTRY="$(usex !dedicated)"
		-DENABLE_NLS="$(usex nls)"
		-DENABLE_NOTIFICATIONS="$(usex dbus)"
		-DENABLE_FRIBIDI="$(usex fribidi)"
		-DENABLE_STRICT_COMPILATION="OFF"
		)
	cmake_src_configure
}

src_install() {
	local DOCS=( README.md changelog.md )
	cmake_src_install
	if use dedicated || use server; then
		rmdir "${ED}/run/wesnothd" || die
		newinitd "${FILESDIR}"/wesnothd.rc-r1 wesnothd
	fi
}
