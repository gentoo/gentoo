# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop

MY_PN1="SamTFE"
MY_PN2="SamTSE"
# Game name
GN1="serioussam"
GN2="serioussamse"

DESCRIPTION="Linux port of Serious Sam Classic with Vulkan support"
HOMEPAGE="https://github.com/tx00100xt/SeriousSamClassic-VK"
SRC_URI="https://github.com/tx00100xt/SeriousSamClassic-VK/archive/refs/tags/${PV}c.tar.gz -> ${P}c.tar.gz"
S="${WORKDIR}/SeriousSamClassic-VK-${PV}c"

MY_CONTENT1="${WORKDIR}/SeriousSamClassic-VK-${PV}c/${MY_PN1}"
MY_CONTENT2="${WORKDIR}/SeriousSamClassic-VK-${PV}c/${MY_PN2}"

LICENSE="GPL-2 BSD ZLIB"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="alsa pipewire vulkan"

RDEPEND="
	games-fps/serioussam-tfe-data
	games-fps/serioussam-tse-data
	media-libs/libsdl2[video,joystick,opengl]
	media-libs/libvorbis
	sys-libs/zlib
	alsa? (
		>=media-libs/libsdl2-2.0.6[alsa,sound]
	)
	pipewire? (
		>=media-libs/libsdl2-2.0.6[pipewire,sound]
	)
	vulkan? (
		dev-util/vulkan-headers
		media-libs/vulkan-loader
		media-libs/libsdl2[video,joystick,opengl,vulkan]
	)
"

DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	sys-devel/flex
	sys-devel/bison
	media-gfx/imagemagick
"

src_configure() {
	einfo "Remove Win32 stuff..."
	rm -rf "${MY_CONTENT1}"/Tools.Win32 || die "Failed to remove stuff Win32"
	rm -rf "${MY_CONTENT2}"/Tools.Win32 || die "Failed to remove stuff Win32"

	einfo "Setting build type Release..."
	CMAKE_BUILD_TYPE="Release"
	local mycmakeargs=(
		-DUSE_SYSTEM_INSTALL=ON
		-DUSE_SYSTEM_VULKAN=$(usex vulkan ON OFF)
		-DUSE_ASM=$(usex x86 OFF ON)
	)
	cmake_src_configure
}

src_install() {
	local dir1="/usr/share/${GN1}"
	local dir2="/usr/share/${GN2}"
	local dir3="/usr/share/applications"
	cmake_src_install

	# install man pages
	mv  "${S}"/man/gentoo/serioussam-vk.1 "${S}"/man/gentoo/serioussam.1 \
		|| die "Failed move man pages"
	doman "${S}"/man/gentoo/serioussam.1

	# removing repo stuff
	rm -fr "${MY_CONTENT1}/Sources" && rm -fr "${MY_CONTENT2}/Sources" \
		|| die "Failed to remove Sources"
	rm -f  "${MY_CONTENT1}"/{*.png,*.desktop} \
		|| die "Failed to remove serioussam icon and desktop file"
	rm -f  "${MY_CONTENT2}"/{*.png,*.desktop} \
		|| die "Failed to remove serioussamse icon and desktop file"
	rm -f  "${ED}${dir3}/${GN1}.desktop" "${ED}${dir3}/${GN2}.desktop" \
		|| die "Failed to remove desktop file"

	# moving repo content (Scripts, Data, Settings ...)
	cp -fr "${MY_CONTENT1}"/* "${ED}${dir1}" \
		|| die "Failed to copy repo content (Scripts, Settings)"
	cp -fr "${MY_CONTENT2}"/* "${ED}${dir2}" \
		|| die "Failed to copy repo content (Scripts, Settings)"

	make_desktop_entry ${GN1} "Serious Sam The First Encounter" ${GN1}
	make_desktop_entry ${GN2} "Serious Sam The Second Encounter" ${GN2}
}

pkg_postinst() {
	elog "     Look at:"
	elog "        man serioussam"
	elog "        https://github.com/tx00100xt/SeriousSamClassic-VK"
	elog "        https://github.com/tx00100xt/SeriousSamClassic-VK/wiki"
	elog "     For information on the first launch of the game"
}
