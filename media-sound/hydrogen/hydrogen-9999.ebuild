# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

case "${PV}" in
	(*9999*)
	KEYWORDS=""
	VCS_ECLASS=git-r3
	EGIT_REPO_URI="git://github.com/hydrogen-music/${PN}.git"
	;;
	(*)
	KEYWORDS="~amd64"
	VCS_ECLASS=vcs-snapshot
	SRC_URI="https://github.com/${PN}-music/${PN}/archive/${PVR/_/-}.tar.gz -> ${P}.tar.gz"
	;;
esac
inherit eutils cmake-utils multilib flag-o-matic toolchain-funcs ${VCS_ECLASS}

DESCRIPTION="Advanced drum machine"
HOMEPAGE="http://www.hydrogen-music.org"

LICENSE="GPL-2 ZLIB"
SLOT="0"
IUSE="+alsa +archive debug doc +extra +jack jack-session ladspa lash oss portaudio portmidi -pulseaudio rubberband static"
REQUIRED_USE="lash? ( alsa )"

# liblo>=0.28 required in order to provide lo_cpp.h to hydrogen-9999
RDEPEND="archive? ( app-arch/libarchive )
	!archive? ( >=dev-libs/libtar-1.2.11-r3 )
	dev-qt/qtgui:4 dev-qt/qtcore:4
	dev-qt/qtxmlpatterns:4
	>=media-libs/libsndfile-1.0.18
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	ladspa? ( media-libs/liblrdf )
	lash? ( media-sound/lash )
	portaudio? ( >=media-libs/portaudio-19_pre )
	portmidi? ( media-libs/portmidi )
	pulseaudio? ( media-sound/pulseaudio )
	rubberband? ( media-libs/rubberband )
	extra? ( media-libs/hydrogen-drumkits )
	>=media-libs/liblo-0.28"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	media-libs/raptor
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog DEVELOPERS README.txt )

S="${WORKDIR}/${PN}-${PVR/_rc/-RC}"

src_configure()
{
	sed -e 's/-O2 //g' -i CMakeLists.txt
	local mycmakeargs=(
	-DWANT_ALSA="$(usex alsa)"
	-DWANT_LIBARCHIVE="$(usex archive)"
	-DWANT_DEBUG="$(usex debug)"
	-DWANT_JACK="$(usex jack)"
	-DWANT_JACKSESSION="$(usex jack-session)"
	-DWANT_LRDF="$(usex ladspa)"
	-DWANT_LASH="$(usex lash)"
	-DWANT_OSS="$(usex oss)"
	-DWANT_PORTAUDIO="$(usex portaudio)"
	-DWANT_PORTMIDI="$(usex portmidi)"
	-DWANT_PULSEAUDIO="$(usex pulseaudio)"
	-DWANT_RUBBERBAND="$(usex rubberband)"
	-DWANT_SHARED="$(usex static)"
	)
	cmake-utils_src_configure
}
