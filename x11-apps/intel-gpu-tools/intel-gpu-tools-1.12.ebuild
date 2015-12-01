# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{3_3,3_4} )

inherit python-single-r1 xorg-2

DESCRIPTION="Intel GPU userland tools"
KEYWORDS="amd64 x86"
IUSE="python test-programs unwind video_cards_nouveau"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="test"

DEPEND="dev-libs/glib:2
	>=x11-libs/cairo-1.12.0
	>=x11-libs/libdrm-2.4.52[video_cards_intel,video_cards_nouveau?]
	>=x11-libs/libpciaccess-0.10
	python? ( ${PYTHON_DEPS} )
	unwind? ( sys-libs/libunwind )"
RDEPEND="${DEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable python dumper)
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
		pushd "${AUTOTOOLS_BUILD_DIR}"/tests || die
			for testprogram in $(<multi-tests.txt) $(<single-tests.txt); do
				if [[ -f ${testprogram} ]]; then
					dobin "${testprogram}"
				fi
			done
		popd
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
