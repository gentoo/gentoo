# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_MIN_API_VERSION="0.22"

inherit gnome2 vala cmake-utils

DESCRIPTION="Simple animated Gif screen recorder"
HOMEPAGE="https://github.com/phw/peek"
SRC_URI="https://github.com/phw/peek/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="keybinder test"

RDEPEND=">=dev-libs/glib-2.38:2
	media-video/ffmpeg[X,encode]
	virtual/imagemagick-tools
	>=x11-libs/gtk+-3.14:3
	keybinder? ( dev-libs/keybinder:3 )"
DEPEND="${RDEPEND}
	$(vala_depend)
	app-text/txt2man
	>=sys-devel/gettext-0.19"

src_prepare() {
	cmake-utils_src_prepare
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DKEYBINDER_FOUND=$(usex keybinder 1 0)
		-DVALA_EXECUTABLE="${VALAC}"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	# Compile helper programs for tests
	if use test; then
		cmake-utils_src_make -C tests
	fi
}
