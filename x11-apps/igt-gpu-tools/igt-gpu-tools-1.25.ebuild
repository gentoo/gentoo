# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
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
IUSE="chamelium doc man overlay runner unwind valgrind video_cards_amdgpu video_cards_intel video_cards_nouveau X xv"
REQUIRED_USE="
	|| ( video_cards_amdgpu video_cards_intel video_cards_nouveau )
	overlay? (
		video_cards_intel
		|| ( X xv )
	)
"
RESTRICT="test"

RDEPEND="
	dev-libs/elfutils
	dev-libs/glib:2
	sys-apps/kmod:=
	sys-libs/libunwind:=
	sys-libs/zlib:=
	sys-process/procps:=
	virtual/libudev:=
	>=x11-libs/cairo-1.12.0[X?]
	>=x11-libs/libdrm-2.4.82[video_cards_amdgpu?,video_cards_intel?,video_cards_nouveau?]
	>=x11-libs/libpciaccess-0.10
	x11-libs/pixman
	chamelium? (
		dev-libs/xmlrpc-c[curl]
		sci-libs/gsl
		media-libs/alsa-lib:=
	)
	overlay? (
		>=x11-libs/libXrandr-1.3
		xv? (
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXv
		)
	)
	runner? ( dev-libs/json-c:= )
	unwind? ( sys-libs/libunwind )
	valgrind? ( dev-util/valgrind )
	"
DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.25-r1 )
	man? ( dev-python/docutils )
	overlay? (
		>=dev-util/peg-0.1.18
		x11-base/xorg-proto
	)
	video_cards_intel? (
		sys-devel/bison
		sys-devel/flex
	)
"

src_prepare() {
	sed -e "s/find_program('rst2man-3'/find_program('rst2man.py', 'rst2man-3'/" -i man/meson.build
	default_src_prepare
}

src_configure() {
	local gpus=""
	use video_cards_amdgpu  && gpus+="amdgpu,"
	use video_cards_intel   && gpus+="intel,"
	use video_cards_nouveau && gpus+="nouveau,"

	local overlay_backends=""
	use overlay && use xv && overlay_backends+="xv,"
	use overlay && use X && overlay_backends+="x,"

	local emesonargs=(
		$(meson_feature chamelium)
		$(meson_feature doc docs)
		$(meson_feature man)
		$(meson_feature overlay)
		$(meson_feature runner)
		$(meson_feature doc tests) # Test build is required for docs
		$(meson_feature valgrind)
		$(meson_feature unwind libunwind)
		-Doverlay_backends=${overlay_backends%?}
		-Dlibdrm_drivers=${gpus%?}
	)
	meson_src_configure
}
