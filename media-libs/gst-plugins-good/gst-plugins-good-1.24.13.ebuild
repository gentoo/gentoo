# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE="gst-plugins-good"

inherit gstreamer-meson virtualx

DESCRIPTION="Basepack of plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2.1+"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="+orc"

# Old media-libs/gst-plugins-ugly blocker for xingmux moving from ugly->good
RDEPEND="
	!<media-libs/gst-plugins-ugly-1.22.3
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}]
	>=virtual/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]
	orc? ( >=dev-lang/orc-0.4.33[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README.md RELEASE )

multilib_src_configure() {
	# gst/matroska can use bzip2
	GST_PLUGINS_NOAUTO="bz2"

	local emesonargs=(
		-Dbz2=enabled
	)

	gstreamer_multilib_src_configure
}

multilib_src_test() {
	# Homebrew test skips for meson
	local -a tests
	tests=( $(meson test --list -C "${BUILD_DIR}") )

	local -a _skip_tests=(
		# known flaky test bug #930448
		# https://gitlab.freedesktop.org/gstreamer/gstreamer/-/issues/2803
		elements_flvmux
	)

	# Add suites which in this case are the project name
	if has_version ">=dev-build/meson-1.9.2"; then
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
