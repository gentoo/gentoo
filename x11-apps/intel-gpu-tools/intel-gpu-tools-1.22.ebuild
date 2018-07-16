# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

XORG_EAUTORECONF="yes"

inherit xorg-2

DESCRIPTION="Intel GPU userland tools"

HOMEPAGE="https://01.org/linuxgraphics https://cgit.freedesktop.org/xorg/app/intel-gpu-tools/"
SRC_URI="https://www.x.org/releases/individual/app/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"
IUSE="alsa chamelium doc glib gsl sound test-programs valgrind video_cards_amdgpu video_cards_intel video_cards_nouveau X xrandr xv"
REQUIRED_USE="
	test-programs? ( sound? ( alsa gsl ) )
	chamelium? ( glib gsl )"
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
	>=dev-util/gtk-doc-1.25-r1"

PATCHES=(
	"${FILESDIR}"/${P}-KBL-ICL-PCI-IDs.patch
)

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
	$(usex test-programs $(use_enable sound audio) --disable-audio)
	$(use_enable chamelium)
	$(use_enable doc gtk-doc)
	$(use_enable test-programs tests)
	$(use_enable video_cards_amdgpu amdgpu)
	$(use_enable video_cards_intel intel)
	$(use_enable video_cards_nouveau nouveau)
	)
	xorg-2_src_configure
}

src_install() {
	xorg-2_src_install
	if use test-programs; then
		local testprogram
		pushd "${AUTOTOOLS_BUILD_DIR}"/tests >/dev/null || die
		for testprogram in $(<multi-tests.txt) $(<single-tests.txt); do
			if [[ -f ${testprogram} ]]; then
				dobin "${testprogram}"
			fi
		done
		popd >/dev/null
	fi
}

pkg_postinst() {
	xorg-2_pkg_postinst
	if use test-programs; then
		elog "Test programs for DRM driver development were installed. These are not"
		elog "designed to run outside their source tree, so may or may not work as"
		elog "intended."
	fi
}
