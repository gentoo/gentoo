# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} pypy3 )
inherit gnome.org meson-multilib xdg-utils virtualx python-any-r1

DESCRIPTION="A library for sending desktop notifications"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libnotify"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="gtk-doc +introspection test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.38:2[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-libs/gobject-introspection-common-1.32
	dev-util/glib-utils
	virtual/pkgconfig
	app-text/docbook-xsl-ns-stylesheets
	dev-libs/libxslt
	gtk-doc? ( dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.1.2 )
	test? (
		x11-libs/gtk+:3[${MULTILIB_USEDEP}]
		sys-apps/dbus[X]
		$(python_gen_any_dep 'dev-python/python-dbusmock[${PYTHON_USEDEP}]')
	)
"
IDEPEND="app-eselect/eselect-notify-send"
PDEPEND="virtual/notification-daemon"

PATCHES=( "${FILESDIR}/debian-autopkgtest.patch" )

python_check_deps() {
	python_has_version -b "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default
	xdg_environment_reset
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_use test tests)
		$(meson_native_use_feature introspection)
		$(meson_native_use_bool gtk-doc gtk_doc)
		-Ddocbook_docs=disabled
	)
	meson_src_configure
}

run_tests() {
	"${EPYTHON}" -m dbusmock -t notification_daemon &
	while ! dbus-send --session --print-reply \
		--dest=org.freedesktop.Notifications \
		/org/freedesktop/Notifications \
		org.freedesktop.Notifications.GetCapabilities; do
		sleep 0.5
	done
	meson_src_test || die
}

multilib_src_test() {
	virtx run_tests
}

multilib_src_install() {
	meson_src_install

	mv "${ED}"/usr/bin/{,libnotify-}notify-send || die #379941
}

pkg_postinst() {
	eselect notify-send update ifunset
}

pkg_postrm() {
	eselect notify-send update ifunset
}
