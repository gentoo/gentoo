# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit xorg-2

DESCRIPTION="Intel GPU userland tools"
KEYWORDS="amd64 x86"
IUSE="test-programs unwind video_cards_nouveau"
RESTRICT="test"

DEPEND="dev-libs/glib:2
	>=x11-libs/cairo-1.12.0
	>=x11-libs/libdrm-2.4.64[video_cards_intel,video_cards_nouveau?]
	>=x11-libs/libpciaccess-0.10
	unwind? ( sys-libs/libunwind )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.12-inttypes.patch #582430
	"${FILESDIR}"/${PN}-1.12-sysmacros.patch #581080
)

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable video_cards_nouveau nouveau)
		$(use_enable test-programs tests)
		$(use_with unwind libunwind)
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
