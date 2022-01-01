# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit bash-completion-r1 meson multilib-minimal systemd udev vala

DESCRIPTION="System service to accurately color manage input and output devices"
HOMEPAGE="https://www.freedesktop.org/software/colord/"
SRC_URI="https://www.freedesktop.org/software/colord/releases/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0/2" # subslot = libcolord soname version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

IUSE="gtk-doc argyllcms examples extra-print-profiles +introspection scanner systemd test +udev vala"
RESTRICT="!test? ( test ) test" # Tests try to read and write files in /tmp
REQUIRED_USE="
	scanner? ( udev )
	vala? ( introspection )
"

DEPEND="
	>=dev-libs/glib-2.58.0:2[${MULTILIB_USEDEP}]
	>=media-libs/lcms-2.6:2=[${MULTILIB_USEDEP}]
	dev-db/sqlite:3=[${MULTILIB_USEDEP}]
	>=dev-libs/libgusb-0.2.7[introspection?,${MULTILIB_USEDEP}]
	udev? (
		dev-libs/libgudev:=[${MULTILIB_USEDEP}]
		virtual/libudev:=[${MULTILIB_USEDEP}]
		virtual/udev
	)
	systemd? ( >=sys-apps/systemd-44:0= )
	scanner? (
		media-gfx/sane-backends
		sys-apps/dbus
	)
	>=sys-auth/polkit-0.104
	argyllcms? ( media-gfx/argyllcms )
	introspection? ( >=dev-libs/gobject-introspection-0.9.8:= )
"
RDEPEND="${DEPEND}
	acct-group/colord
	acct-user/colord
"
BDEPEND="
	acct-group/colord
	acct-user/colord
	app-text/docbook-xsl-ns-stylesheets
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	extra-print-profiles? ( media-gfx/argyllcms )
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}"/${PV}-tests-Don-t-use-exact-floating-point-comparisons.patch
	"${FILESDIR}"/${PV}-optional-introspection.patch
)

src_prepare() {
	default
	use vala && vala_src_prepare

	# Test requires a running session
	# https://github.com/hughsie/colord/issues/94
	sed -i -e "/test('colord-test-daemon'/d" lib/colord/meson.build || die

	# Adapt to Gentoo paths
	sed -i \
		-e "s|find_program('spotread'|find_program('argyll-spotread'|" \
		-e "s|find_program('colprof'|find_program('argyll-colprof'|" \
		meson.build || die

	# meson gnome.generate_vapi properly handles VAPIGEN and other vala
	# environment variables. It is counter-productive to check for an
	# unversioned vapigen, as that breaks versioned VAPIGEN usages.
	sed -i -e "/find_program('vapigen')/d" meson.build || die
}

multilib_src_configure() {
	local emesonargs=(
		-Ddaemon=$(multilib_is_native_abi && echo true || echo false)
		-Dexamples=false
		-Dbash_completion=false
		$(meson_use udev udev_rules)
		-Dsystemd=$(multilib_native_usex systemd true false)
		-Dlibcolordcompat=true
		-Dargyllcms_sensor=$(multilib_native_usex argyllcms true false)
		-Dreverse=false
		-Dsane=$(multilib_native_usex scanner true false)
		-Dintrospection=$(multilib_native_usex introspection true false)
		-Dvapi=$(multilib_native_usex vala true false)
		-Dprint_profiles=$(multilib_native_usex extra-print-profiles true false)
		$(meson_use test tests)
		-Dinstalled_tests=false
		-Ddaemon_user=colord
		-Dman=true
		$(meson_use gtk-doc docs)
		--localstatedir="${EPREFIX}"/var
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	newbashcomp data/colormgr colormgr

	# Ensure config and profile directories exist and /var/lib/colord/*
	# is writable by colord user
	keepdir /var/lib/color{,d}/icc
	fowners colord:colord /var/lib/colord{,/icc}

	if use examples; then
		docinto examples
		dodoc examples/*.c
	fi
}
