# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/wayland/wayland.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/wayland/${PN}/-/releases/${PV}/downloads/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi
inherit meson-multilib

DESCRIPTION="Wayland protocol libraries"
HOMEPAGE="https://wayland.freedesktop.org/ https://gitlab.freedesktop.org/wayland/wayland"

LICENSE="MIT doc? ( Apache-2.0 OFL-1.1 )"
SLOT="0"
IUSE="doc test selinux"
RESTRICT="!test? ( test )"

BDEPEND="
	~dev-util/wayland-scanner-${PV}
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		app-text/mdbook
		app-text/xmlto
		media-gfx/graphviz
	)
"
DEPEND="
	>=dev-libs/libffi-3.0.13-r1:=[${MULTILIB_USEDEP}]
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-wayland )
"

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
	# Tests create sockets under XDG_RUNTIME_DIR, and socket paths are limited
	# to 108 bytes. A directory under ${T} easily exceeds that, so use a short
	# one in /tmp instead (bug #664650).
	export XDG_RUNTIME_DIR=$(mktemp -d /tmp/wayland-XXXXXX) || die

	# Sockets are created at
	#   ${XDG_RUNTIME_DIR}/wayland-tests-XXXXXX/wayland-test-${PID}-${SEC}${USEC}
	# With a 7 digit PID, 10 digit seconds, and 6 digit microseconds, the
	# suffix is 59 bytes. With the NUL, that leaves 48 of the 108 byte
	# sun_path for XDG_RUNTIME_DIR.
	if [[ ${#XDG_RUNTIME_DIR} -gt 48 ]]; then
		die "XDG_RUNTIME_DIR ${XDG_RUNTIME_DIR} too long for socket paths"
	fi

	multilib-minimal_src_test

	rm -rf "${XDG_RUNTIME_DIR}" || die
}

src_install() {
	meson-multilib_src_install

	if use doc; then
		mv "${ED}"/usr/share/doc/{${PN}/Wayland,${PF}/html} || die
		rmdir "${ED}"/usr/share/doc/${PN} || die
	fi
}
