# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

DESCRIPTION="Qt application to control FluidSynth"
HOMEPAGE="https://qsynth.sourceforge.io/"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.code.sf.net/p/qsynth/code"
	inherit git-r3
else
	SRC_URI="https://downloads.sourceforge.net/qsynth/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+alsa debug jack pulseaudio"

REQUIRED_USE="|| ( alsa jack pulseaudio )"

DEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	dev-qt/qtsvg:6
	media-sound/fluidsynth:=[jack?,alsa?,pulseaudio?]
"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DCONFIG_DEBUG=$(usex debug 1 0)
		-DCONFIG_QT6=1
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# The desktop file is invalid, and we also change the command
	# depending on useflags
	rm "${D}/usr/share/applications/org.rncbc.qsynth.desktop" || die

	local args
	if use pulseaudio; then
		args="-a pulseaudio"
	elif use alsa; then
		args="-a alsa"
	else
		args="-a oss"
	fi

	make_desktop_entry --eapi9 qsynth -a "${args}" -n Qsynth -i org.rncbc.qsynth
}
