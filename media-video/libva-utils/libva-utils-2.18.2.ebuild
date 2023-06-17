# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Collection of utilities and tests for VA-API"
HOMEPAGE="https://01.org/linuxmedia/vaapi"
if [[ ${PV} = *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/intel/libva-utils"
else
	SRC_URI="https://github.com/intel/libva-utils/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm64 ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
fi

LICENSE="MIT"
SLOT="0"
IUSE="examples putsurface test +vainfo wayland X"
RESTRICT="test" # Tests must be run manually

REQUIRED_USE="
	putsurface? ( || ( wayland X ) )
	|| ( examples putsurface test vainfo )
"

DEPEND="
	x11-libs/libdrm
	wayland? ( >=dev-libs/wayland-1.0.6 )
	X? ( >=x11-libs/libX11-1.6.2 )
"
if [[ ${PV} = *9999 ]] ; then
	DEPEND+="~media-libs/libva-${PV}:=[wayland?,X?]"
else
	DEPEND+=">=media-libs/libva-$(ver_cut 1-2).0:=[wayland?,X?]"
fi
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	local sed_args=()

	if ! use examples ; then
		sed_args+=(
			-e "/^  subdir('decode')$/d"
			-e "/^  subdir('encode')$/d"
			-e "/^  subdir('videoprocess')$/d"
			-e "/^  subdir('vendor\/intel')$/d"
			-e "/^  subdir('vendor\/intel\/sfcsample')$/d"
		)
	fi

	if ! use putsurface ; then
		sed_args+=(-e "/^  subdir('putsurface')$/d")
	fi

	if ! use vainfo ; then
		sed_args+=(-e "/^subdir('vainfo')$/d")
	fi

	if [[ ${#sed_args[@]} -gt 0 ]] ; then
		sed "${sed_args[@]}" -i meson.build || die
	fi
}

src_configure() {
	local emesonargs=(
		-Ddrm=true
		$(meson_use X x11)
		$(meson_use wayland)
		$(meson_use test tests)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if ! use test ; then
		rm -f "${ED}"/usr/bin/test_va_api || die
	fi
}

pkg_postinst() {
	if use test ; then
		elog "Tests must be run manually with the test_va_api binary"
	fi
}
