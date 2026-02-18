# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )

inherit meson python-r1

DESCRIPTION="SDK for making video editors and more"
HOMEPAGE="http://wiki.pitivi.org/wiki/GES"
SRC_URI="https://gstreamer.freedesktop.org/src/${PN}/${P/gstreamer/gst}.tar.xz"
S="${WORKDIR}"/${P/gstreamer/gst}

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="amd64 ~arm64 x86"

IUSE="+introspection test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

# <pygobject-3.52: bug 957940
RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.40.0:2
	<dev-python/pygobject-3.52[${PYTHON_USEDEP}]
	>=media-libs/gstreamer-${PV}:1.0[introspection?]
	>=media-libs/gst-plugins-base-${PV}:1.0[introspection?]
	>=media-libs/gst-plugins-bad-${PV}:1.0[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
"
# gst-plugins-good needed for tests: assertion 'GST_IS_ELEMENT (element)' failed
DEPEND="${RDEPEND}
	test? ( >=media-libs/gst-plugins-good-${PV}:1.0 )
"
BDEPEND="virtual/pkgconfig"

src_configure() {
	python_setup

	local emesonargs=(
		-Ddoc=disabled # hotdoc not packaged
		$(meson_feature introspection)
		$(meson_feature test tests)
		-Dbash-completion=disabled
		-Dxptv=disabled
		-Dpython=enabled
		-Dvalidate=disabled
		-Dexamples=disabled
	)
	meson_src_configure
}

src_test() {
	# Homebrew test skips for meson
	local -a tests
	tests=( $(meson test --list -C "${BUILD_DIR}") )

	local -a _skip_tests=(
		# tests/check/ges/uriclip.c:71:F:filesource:test_filesource_basic:0: 'g_list_length (trackelements)' (0) is not equal to '1' (1)
		# tests/check/ges/uriclip.c:244:F:filesource:test_filesource_images:0: Assertion 'ges_uri_clip_asset_is_image (GES_URI_CLIP_ASSET (asset))' failed
		ges_uriclip
		# tests/check/ges/asset.c:229:F:a:test_uri_clip_change_asset:0: 'g_list_length (GES_CONTAINER_CHILDREN (extractable))' (1) is not equal to '2' (2)
		ges_asset
		# tests/check/ges/project.c:248:F:project:test_project_load_xges:0: 'g_list_length (trackelements)' (0) is not equal to '2' (2)
		ges_project
		# tests/check/nle/common.c:50:F:tempochange:test_tempochange_play:0: Failed to make element pitch
		# tests/check/nle/common.c:50:F:tempochange:test_tempochange_seek:0: Failed to make element pitch

		nle_tempochange
		# tests/check/ges/clip.c:2515:F:clip:test_children_max_duration:0: Assertion 'ges_layer_add_clip (layer, GES_CLIP (clip))' failed
		# tests/check/ges/clip.c:3802:F:clip:test_rate_effects_duration_limit:0: Assertion 'ges_base_effect_is_time_effect (GES_BASE_EFFECT (pitch))' failed

		ges_clip
	)

	# Add suites which in this case are the project name
	if has_version ">=dev-build/meson-1.9.2"; then
		local -a skip_tests=()
		for skip_test in ${_skip_tests[@]}; do
			skip_tests+=( "gst-editing-services:${skip_test}" )
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

	meson_src_test ${tests[@]}
}

src_install() {
	meson_src_install
	python_moduleinto gi.overrides
	python_foreach_impl python_domodule bindings/python/gi/overrides/GES.py
}
