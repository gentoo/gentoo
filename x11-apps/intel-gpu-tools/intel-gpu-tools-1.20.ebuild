# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit xorg-2

DESCRIPTION="Intel GPU userland tools"

KEYWORDS="~amd64 ~x86"
IUSE="alsa glib gsl sound test-programs udev unwind valgrind video_cards_amdgpu video_cards_intel video_cards_nouveau X xrandr xv"
REQUIRED_USE="test-programs? ( sound? ( alsa gsl ) )"
RESTRICT="test"

X86_RDEPEND="
	xv? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXv
	)"
X86_DEPEND=">=x11-proto/dri2proto-2.6"
RDEPEND="sys-apps/kmod:=
	sys-process/procps:=
	>=x11-libs/cairo-1.12.0[X?]
	>=x11-libs/libdrm-2.4.82[video_cards_amdgpu?,video_cards_intel?,video_cards_nouveau?]
	>=x11-libs/libpciaccess-0.10
	alsa? ( media-libs/alsa-lib:= )
	glib? ( dev-libs/glib:2 )
	gsl? ( sci-libs/gsl )
	udev? ( virtual/libudev:= )
	unwind? ( sys-libs/libunwind )
	valgrind? ( dev-util/valgrind )
	video_cards_intel? ( sys-libs/zlib:= )
	xrandr? ( >=x11-libs/libXrandr-1.3 )
	amd64? ( ${X86_RDEPEND} )
	x86? ( ${X86_RDEPEND} )"
DEPEND="${RDEPEND}
	amd64? ( ${X86_DEPEND} )
	x86? ( ${X86_DEPEND} )"

src_configure() {
	sed -i -E \
		-e "s:\<alsa=(no|yes):alsa=$(usex alsa):g" \
		-e "s:\<glib=(no|yes):glib=$(usex glib):g" \
		-e "s:\<gsl=(no|yes):gsl=$(usex gsl):g" \
		-e "s:\<udev=(no|yes):udev=$(usex udev):g" \
		-e "s:\<have_valgrind=(no|yes):have_valgrind=$(usex valgrind):g" \
		-e "s:\<enable_overlay_xvlib=(no|yes):enable_overlay_xvlib=$(usex xv):g" \
		configure || die
	XORG_CONFIGURE_OPTIONS=(
		$(usex test-programs $(use_enable sound audio) --disable-audio)
		$(use_enable test-programs tests)
		$(use_with unwind libunwind)
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
