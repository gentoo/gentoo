# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..12} python3_{13..14}{,t} )

inherit flag-o-matic gnome.org gnome2-utils meson python-any-r1 systemd xdg

DESCRIPTION="Indexer and search engine that powers desktop search for core GNOME components"
HOMEPAGE="https://gnome.pages.gitlab.gnome.org/localsearch"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="cue exif ffmpeg gif gsf +gstreamer iptc +iso +jpeg networkmanager +pdf +playlist raw +rss seccomp test +tiff upower +xml xmp xps"

REQUIRED_USE="cue? ( gstreamer )" # cue is currently only supported via gstreamer, not ffmpeg
RESTRICT="!test? ( test )"

# tracker-2.1.7 currently always depends on ICU (theoretically could be libunistring instead);
# so choose ICU over enca always here for the time being (ICU is preferred)
RDEPEND="
	>=app-misc/tinysparql-3.8:3
	>=sys-apps/dbus-1.3.1
	xmp? ( >=media-libs/exempi-2.1.0:= )
	raw? ( media-libs/gexiv2 )
	>=dev-libs/glib-2.70:2
	dev-libs/gobject-introspection
	cue? ( media-libs/libcue:= )
	exif? ( >=media-libs/libexif-0.6 )
	gsf? ( >=gnome-extra/libgsf-1.14.24:= )
	xps? ( app-text/libgxps )
	iptc? ( media-libs/libiptcdata )
	jpeg? ( media-libs/libjpeg-turbo:0= )
	iso? ( >=sys-libs/libosinfo-1.10.0-r1 )
	>=media-libs/libpng-1.2:0=
	seccomp? ( >=sys-libs/libseccomp-2.0 )
	tiff? ( media-libs/tiff:= )
	xml? ( >=dev-libs/libxml2-2.6:= )
	pdf? ( >=app-text/poppler-0.16.0:=[cairo] )
	playlist? ( >=dev-libs/totem-pl-parser-3:= )
	sys-apps/util-linux

	gif? ( media-libs/giflib:= )

	networkmanager? ( net-misc/networkmanager )

	rss? ( >=net-libs/libgrss-0.7:0 )
	app-arch/gzip

	upower? ( >=sys-power/upower-0.9.0:= )

	>=dev-libs/icu-4.8.1.1:=

	gstreamer? (
		>=media-libs/gstreamer-1.20:1.0
		>=media-libs/gst-plugins-base-1.20:1.0
		>=media-plugins/gst-plugins-meta-1.20:1.0 )
	!gstreamer? (
		ffmpeg? ( media-video/ffmpeg:0= ) )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/asciidoc
	dev-libs/libxslt
	dev-util/glib-utils
	dev-util/gdbus-codegen

	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/pygobject[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/tap-py[${PYTHON_USEDEP}]')
		gstreamer? (
			media-libs/gstreamer:1.0[introspection]
			|| (
				media-plugins/gst-plugins-libav:1.0
				media-plugins/gst-plugins-openh264:1.0
			)
		)
	)
"

python_check_deps() {
	python_has_version -b \
		"dev-python/pygobject[${PYTHON_USEDEP}]" \
		"dev-python/tap-py[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	# Avoid gst-inspect calls that may trigger sandbox;
	# instead assume the detection will succeed and add the needed test deps for that
	if use gstreamer; then
		sed -i -e 's:detect-h264-codec.sh:/bin/true:' tests/functional-tests/meson.build || die
	else
		sed -i -e 's:detect-h264-codec.sh:/bin/false:' tests/functional-tests/meson.build || die
	fi
	gnome2_environment_reset # sets gstreamer safety variables
}

src_configure() {
	# bug #944218
	append-cflags -std=gnu17

	append-cflags -DTRACKER_DEBUG -DG_DISABLE_CAST_CHECKS

	local media_extractor="none"
	if use gstreamer ; then
		media_extractor="gstreamer"
	elif use ffmpeg ; then
		media_extractor="libav"
	fi

	local emesonargs=(
		-Dman=true
		-Dextract=true
		$(meson_use test functional_tests)
		$(meson_use test tests_tap_protocol)
		-Dminer_fs=true
		$(meson_use rss miner_rss)
		-Dwriteback=true
		-Dabiword=true
		-Dicon=true
		-Dmp3=true
		-Dps=true
		-Dtext=true
		-Dunzip_ps_gz_files=true # spawns gunzip

		$(meson_feature networkmanager network_manager)
		$(meson_feature cue)
		$(meson_feature exif)
		$(meson_feature gif)
		$(meson_feature gsf)
		$(meson_feature iptc)
		$(meson_feature iso)
		$(meson_feature jpeg)
		$(meson_feature pdf)
		$(meson_feature playlist)
		-Dpng=enabled
		$(meson_feature raw)
		$(meson_feature tiff)
		$(meson_feature xml)
		$(meson_feature xmp)
		$(meson_feature xps)

		-Dbattery_detection=$(usex upower upower none)
		# enca is a possibility, but right now we have tracker core always dep on icu and icu is preferred over enca
		-Dcharset_detection=icu
		-Dgeneric_media_extractor=${media_extractor}
		# gupnp gstreamer_backend is in bad state, upstream suggests to use discoverer, which is the default
		-Dsystemd_user_services_dir="$(systemd_get_userunitdir)"
	)
	meson_src_configure
}

src_test() {
	export GSETTINGS_BACKEND="dconf" # Tests require dconf and explicitly check for it (env_reset set it to "memory")
	export PYTHONPATH="${EROOT}"/usr/$(get_libdir)/tracker-3.0
	dbus-run-session meson test -C "${BUILD_DIR}" || die 'tests failed'
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
