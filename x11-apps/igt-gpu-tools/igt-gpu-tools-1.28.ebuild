# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EGIT_REPO_URI="https://gitlab.freedesktop.org/drm/${PN}.git"
if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS="git-r3"
fi

PYTHON_COMPAT=( python3_{10..12} )
inherit ${GIT_ECLASS} meson python-any-r1

DESCRIPTION="Intel GPU userland tools"

HOMEPAGE="https://gitlab.freedesktop.org/drm/igt-gpu-tools"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://www.x.org/releases/individual/app/${P}.tar.xz"
fi
LICENSE="MIT"
SLOT="0"
IUSE="chamelium doc man overlay runner tests unwind valgrind video_cards_amdgpu video_cards_intel video_cards_nouveau X xv"
REQUIRED_USE="
	|| ( video_cards_amdgpu video_cards_intel video_cards_nouveau )
	overlay? (
		video_cards_intel
		|| ( X xv )
	)
	doc? ( tests )
	runner? ( tests )
"
RESTRICT="test"

RDEPEND="
	dev-libs/elfutils
	dev-libs/glib:2
	sys-apps/kmod
	sys-libs/zlib:=
	sys-process/procps:=
	virtual/libudev:=
	>=x11-libs/cairo-1.12.0[X?]
	>=x11-libs/libdrm-2.4.82[video_cards_amdgpu?,video_cards_intel?,video_cards_nouveau?]
	>=x11-libs/libpciaccess-0.10
	x11-libs/pixman
	chamelium? (
		dev-libs/xmlrpc-c:=[curl]
		sci-libs/gsl:=
		media-libs/alsa-lib
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
	unwind? ( sys-libs/libunwind:= )
	valgrind? ( dev-debug/valgrind )
	"
DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.25-r1 )
	man? ( dev-python/docutils )
	overlay? (
		>=dev-util/peg-0.1.18
		x11-base/xorg-proto
	)
	video_cards_intel? (
		app-alternatives/yacc
		app-alternatives/lex
	)
"
BDEPEND="${PYTHON_DEPS}"

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
		$(meson_feature overlay)
		-Doverlay_backends=${overlay_backends%?}
		$(meson_feature chamelium)
		$(meson_feature valgrind)
		$(meson_feature man)
		-Dtestplan=disabled
		-Dsphinx=disabled
		$(meson_feature doc docs)
		$(meson_feature tests)
		-Dxe_driver=disabled
		-Dlibdrm_drivers=${gpus%?}
		$(meson_feature unwind libunwind)
		$(meson_feature runner)
	)
	meson_src_configure
}
