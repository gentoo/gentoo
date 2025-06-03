# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_OPTIONAL=1
RUST_MIN_VER=1.48
inherit gstreamer-meson rust

DESCRIPTION="Open source multimedia framework"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://${PN}.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+caps +introspection ptp unwind"

RDEPEND="
	>=dev-libs/glib-2.64.0:2[${MULTILIB_USEDEP}]
	caps? ( sys-libs/libcap[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
	unwind? (
		>=sys-libs/libunwind-1.8.1[${MULTILIB_USEDEP}]
		dev-libs/elfutils[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	app-alternatives/yacc
	app-alternatives/lex
	ptp? ( ${RUST_DEPEND} )
"

DOCS=( AUTHORS ChangeLog NEWS MAINTAINERS README.md RELEASE )

PATCHES=(
	"${FILESDIR}"/gstreamer-1.24.10-disable-test-with-no-tools.patch
)

# Rust
QA_FLAGS_IGNORED="usr/libexec/gstreamer-1.0/gst-ptp-helper"

pkg_setup() {
	gstreamer-meson_pkg_setup
	use ptp && rust_pkg_setup
}

multilib_src_configure() {
	local emesonargs=(
		-Dtools=$(multilib_is_native_abi && echo enabled || echo disabled)
		-Dbenchmarks=disabled
		-Dexamples=disabled
		-Dcheck=enabled
		-Dpoisoning=true
		-Dptp-helper=$(multilib_is_native_abi && echo $(usex 'ptp' 'enabled' 'disabled') || echo disabled)
		$(meson_feature unwind libunwind)
		$(meson_feature unwind libdw)
	)

	if use caps ; then
		emesonargs+=( -Dptp-helper-permissions=capabilities )
	else
		emesonargs+=(
			-Dptp-helper-permissions=setuid-root
			-Dptp-helper-setuid-user=nobody
			-Dptp-helper-setuid-group=nobody
		)
	fi

	gstreamer_multilib_src_configure
}
