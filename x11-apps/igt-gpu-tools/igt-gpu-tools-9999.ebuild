# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGIT_REPO_URI="https://gitlab.freedesktop.org/drm/${PN}.git"
if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS="git-r3"
fi

inherit ${GIT_ECLASS} meson

DESCRIPTION="Intel GPU userland tools"

HOMEPAGE="https://01.org/linuxgraphics https://gitlab.freedesktop.org/drm/igt-gpu-tools"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://www.x.org/releases/individual/app/${P}.tar.xz"
fi
LICENSE="MIT"
SLOT="0"
IUSE="alsa chamelium doc glib gsl sound valgrind video_cards_amdgpu video_cards_intel video_cards_nouveau X xrandr xv"
REQUIRED_USE="chamelium? ( glib gsl )"
RESTRICT="test"

X86_RDEPEND="
	xv? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXv
	)"
X86_DEPEND="x11-base/xorg-proto
	>=dev-util/peg-0.1.18"
RDEPEND="sys-apps/kmod:=
	sys-libs/libunwind:=
	sys-process/procps:=
	virtual/libudev:=
	>=x11-libs/cairo-1.12.0[X?]
	>=x11-libs/libdrm-2.4.82[video_cards_amdgpu?,video_cards_intel?,video_cards_nouveau?]
	>=x11-libs/libpciaccess-0.10
	alsa? ( media-libs/alsa-lib:= )
	chamelium? ( dev-libs/xmlrpc-c )
	glib? ( dev-libs/glib:2 )
	gsl? ( sci-libs/gsl )
	valgrind? ( dev-util/valgrind )
	video_cards_intel? ( sys-libs/zlib:= )
	xrandr? ( >=x11-libs/libXrandr-1.3 )
	amd64? ( ${X86_RDEPEND} )
	x86? ( ${X86_RDEPEND} )"
DEPEND="${RDEPEND}
	amd64? ( ${X86_DEPEND} )
	x86? ( ${X86_DEPEND} )
	doc? ( >=dev-util/gtk-doc-1.25-r1 )"
