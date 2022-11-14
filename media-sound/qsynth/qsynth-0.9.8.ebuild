# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

DESCRIPTION="Qt application to control FluidSynth"
HOMEPAGE="https://qsynth.sourceforge.io/"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.code.sf.net/p/qsynth/code"
	inherit git-r3
else
	SRC_URI="mirror://sourceforge/qsynth/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+alsa debug jack pulseaudio"

REQUIRED_USE="|| ( alsa jack pulseaudio )"

BDEPEND="
	dev-qt/linguist-tools:5
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-sound/fluidsynth:=[jack?,alsa?,pulseaudio?]
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-0.9.1-cmake-no-git-version.patch" )

src_prepare() {
	cmake_src_prepare

	sed -e "/^find_package.*QT/s/Qt6 //" -i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCONFIG_DEBUG=$(usex debug 1 0)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# The desktop file is invalid, and we also change the command
	# depending on useflags
	rm "${D}/usr/share/applications/org.rncbc.qsynth.desktop" || die

	local cmd
	if use jack; then
		cmd="qsynth"
	elif use pulseaudio; then
		cmd="qsynth -a pulseaudio"
	elif use alsa; then
		cmd="qsynth -a alsa"
	else
		cmd="qsynth -a oss"
	fi

	make_desktop_entry "${cmd}" Qsynth qsynth
}
