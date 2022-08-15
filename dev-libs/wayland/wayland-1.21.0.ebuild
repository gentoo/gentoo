# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/wayland/wayland.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/wayland/${PN}/-/releases/${PV}/downloads/${P}.tar.xz"
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"
fi
inherit meson-multilib

DESCRIPTION="Wayland protocol libraries"
HOMEPAGE="https://wayland.freedesktop.org/ https://gitlab.freedesktop.org/wayland/wayland"

LICENSE="MIT"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	~dev-util/wayland-scanner-${PV}
	virtual/pkgconfig
	doc? (
		>=app-doc/doxygen-1.6[dot]
		app-text/xmlto
		>=media-gfx/graphviz-2.26.0
	)
"
DEPEND="
	>=dev-libs/libffi-3.0.13-r1:=[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_bool doc documentation)
		$(meson_native_true dtd_validation)
		-Dlibraries=true
		-Dscanner=false
		$(meson_use test tests)
	)
	meson_src_configure
}

src_test() {
	# We set it on purpose to only a short subdir name, as socket paths are
	# created in there, which are 108 byte limited. With this it hopefully
	# barely fits to the limit with /var/tmp/portage/${CATEGORY}/${PF}/temp/x
	export XDG_RUNTIME_DIR="${T}"/x
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	multilib-minimal_src_test
}
