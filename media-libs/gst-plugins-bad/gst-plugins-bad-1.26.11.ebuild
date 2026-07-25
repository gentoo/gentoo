# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE="gst-plugins-bad"
inherit gstreamer-meson verify-sig virtualx

DESCRIPTION="Less plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI+=" verify-sig? ( https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz.asc )"

LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="X bzip2 +introspection +orc udev vaapi vnc vulkan wayland"
REQUIRED_USE="vulkan? ( || ( X wayland ) )"

# X11 is automagic for now, upstream #709530 - only used by librfb USE=vnc plugin
# Baseline requirement for libva is 1.6, but 1.15 gets more features
RDEPEND="
	!media-plugins/gst-plugins-va
	!media-plugins/gst-transcoder

	>=media-libs/gstreamer-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )

	bzip2? ( >=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}] )
	vnc? ( X? ( x11-libs/libX11[${MULTILIB_USEDEP}] ) )
	vulkan? (
		media-libs/vulkan-loader[${MULTILIB_USEDEP}]
		X? (
			x11-libs/libxcb:=[${MULTILIB_USEDEP}]
			x11-libs/libxkbcommon[${MULTILIB_USEDEP}]
		)
	)
	wayland? (
		>=dev-libs/wayland-1.4.0[${MULTILIB_USEDEP}]
		>=x11-libs/libdrm-2.4.98[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.26
	)

	orc? ( >=dev-lang/orc-0.4.41[${MULTILIB_USEDEP}] )

	vaapi? (
		>=media-libs/libva-1.15:=[${MULTILIB_USEDEP}]
		udev? ( dev-libs/libgudev[${MULTILIB_USEDEP}] )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	verify-sig? ( sec-keys/openpgp-keys-tpm )
	wayland? ( dev-util/wayland-scanner )
"

DOCS=( AUTHORS ChangeLog NEWS README.md RELEASE )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/tpm.asc

PATCHES=(
	"${FILESDIR}"/gst-plugins-bad-1.26.11-respect-webrtcdsp-disable.patch
	# bug #974283
	"${FILESDIR}"/gst-plugins-bad-1.26.11-GStreamer-SA-2026-0014.patch
	# bug #974284
	"${FILESDIR}"/gst-plugins-bad-1.26.11-GStreamer-SA-2026-0013.patch
	"${FILESDIR}"/gst-plugins-bad-1.26.11-GStreamer-SA-2026-0015.patch
	"${FILESDIR}"/gst-plugins-bad-1.26.11-GStreamer-SA-2026-0017.patch
)

src_prepare() {
	default
	addpredict /dev # Prevent sandbox violations bug #570624
}

multilib_src_configure() {
	GST_PLUGINS_NOAUTO="tinyalsa bz2 hls ipcpipeline lcevcdecoder lcevcencoder librfb shm va vulkan wayland"

	local emesonargs=(
		-Dshm=enabled
		-Dipcpipeline=enabled
		-Dhls=disabled
		-Dlcevcdecoder=disabled # unpackaged dependencies
		-Dlcevcencoder=disabled # requires a dependency with a proprietary license and no public download
		-Dtinyalsa=disabled
		$(meson_feature bzip2 bz2)
		$(meson_feature vaapi va)
		$(meson_feature vulkan)
		$(meson_feature vulkan vulkan-video)
		-Dudev=$(usex udev $(usex vaapi enabled disabled) disabled)
		$(meson_feature vnc librfb)
		-Dx11=$(usex X $(usex vnc enabled disabled) disabled)
		$(meson_feature wayland)
	)

	if use vulkan; then
		local windowing=(
			$(usev X x11)
			$(usev wayland)
		)
		emesonargs+=(
			-Dvulkan-windowing=$(IFS=','; echo "${windowing[*]}")
		)
	fi

	gstreamer_multilib_src_configure
}

multilib_src_test() {
	# Homebrew test skips for meson
	local -a tests
	tests=( $(meson test --list -C "${BUILD_DIR}") )

	local -a _skip_tests=(
		# known flaky test bug #931737
		elements_netsim

		# FIXME
		# gst_harness_new_with_padnames: assertion failed: (element != NULL)
		elements_aesenc
		elements_aesdec
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

	# Tests are slower than upstream expects
	local -x CK_DEFAULT_TIMEOUT=300

	# gstreamer_multilib_src_test doesn't pass arguments
	GST_GL_WINDOW=x11 virtx meson_src_test --timeout-multiplier 5 ${tests[@]}
}
