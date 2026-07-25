# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_OPTIONAL=1
RUST_MIN_VER=1.48
inherit gstreamer-meson rust verify-sig virtualx

DESCRIPTION="Open source multimedia framework"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="
	https://${PN}.freedesktop.org/src/${PN}/${P}.tar.xz
	verify-sig? ( https://${PN}.freedesktop.org/src/${PN}/${P}.tar.xz.asc )
"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="+caps +introspection ptp unwind"

# gstreamer-1.22.x requires 2.62, but 2.64 is strongly recommended
RDEPEND="
	>=dev-libs/glib-2.64.0:2[${MULTILIB_USEDEP}]
	caps? ( sys-libs/libcap[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
	unwind? (
		>=sys-libs/libunwind-1.2_rc1[${MULTILIB_USEDEP}]
		dev-libs/elfutils[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	app-alternatives/yacc
	app-alternatives/lex
	ptp? ( ${RUST_DEPEND} )
	verify-sig? ( sec-keys/openpgp-keys-tpm )
"

DOCS=( AUTHORS ChangeLog NEWS MAINTAINERS README.md RELEASE )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/tpm.asc

# Rust
QA_FLAGS_IGNORED="usr/.*/libexec/gstreamer-1.0/gst-ptp-helper"

pkg_setup() {
	gstreamer-meson_pkg_setup
	use ptp && rust_pkg_setup
}

multilib_src_configure() {
	local emesonargs=(
		# Install tools for all abi's in separate dirs bug #870361
		-Dtools=enabled
		-Dlibexecdir=$(get_libdir)/libexec

		-Dbenchmarks=disabled
		-Dexamples=disabled
		-Dcheck=enabled
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

multilib_src_test() {
	# Homebrew test skips for meson
	local -a tests
	tests=( $(meson test --list -C "${BUILD_DIR}") )

	local -a _skip_tests=(
		# flaky
		gst_gstbin
	)

	# Add suites which in this case are PN
	if has_version ">=dev-build/meson-1.10.0"; then
		local -a skip_tests=()
		for skip_test in ${_skip_tests[@]}; do
			skip_tests+=( "${PN}:${skip_test}" )
		done
	else
		local -a skip_tests=( ${_skip_tests[@]} )
	fi
	unset _skip_tests

	for test_index in ${!tests[@]}; do
		if [[ ${skip_tests[@]} =~ ${tests[${test_index}]} ]]; then
			unset tests[${test_index}]
		fi
	done

	# gstreamer_multilib_src_test doesn't pass arguments
	GST_GL_WINDOW=x11 virtx meson_src_test --timeout-multiplier 5 ${tests[@]}
}
