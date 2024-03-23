# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit meson python-any-r1 systemd udev xdg-utils

DESCRIPTION="D-Bus abstraction for enumerating power devices, querying history and statistics"
HOMEPAGE="https://upower.freedesktop.org/"
SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-2+"
SLOT="0/3" # based on SONAME of libupower-glib.so
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# gtk-doc files are not available as prebuilt in the tarball
IUSE="doc +introspection ios selinux test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.58:2
	sys-apps/dbus:=
	introspection? ( dev-libs/gobject-introspection:= )
	kernel_linux? (
		>=dev-libs/libgudev-236:=
		virtual/udev
		ios? (
			>=app-pda/libimobiledevice-1:=
			>=app-pda/libplist-2:=
		)
	)
"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-devicekit )
"
BDEPEND="
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
	test? (
		$(python_gen_any_dep '
			dev-python/dbus-python[${PYTHON_USEDEP}]
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
		')
		dev-util/umockdev
	)
"

QA_MULTILIB_PATHS="usr/lib/${PN}/.*"

python_check_deps() {
	python_has_version -b "dev-python/dbus-python[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default
	xdg_environment_reset
}

src_configure() {
	local backend

	if use kernel_linux ; then
		backend=linux
	else
		backend=dummy
	fi

	local emesonargs=(
		--localstatedir "${EPREFIX}"/var

		-Dman=true
		$(meson_use doc gtk-doc)
		$(meson_feature introspection)
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Dos_backend="${backend}"
		$(meson_feature ios idevice)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	keepdir /var/lib/upower #383091
}

pkg_postinst() {
	udev_reload

	if [[ ${REPLACING_VERSIONS} ]] && ver_test ${REPLACING_VERSIONS} -lt 0.99.12; then
		elog "Support for Logitech Unifying Receiver battery state readout was"
		elog "removed in version 0.99.12, these devices have been directly"
		elog "supported by the Linux kernel since version >=3.2."
		elog
		elog "Support for CSR devices battery state was removed from udev rules"
		elog "in version 0.99.12. This concerns the following Logitech products"
		elog "from the mid 2000s:"
		elog "Mouse/Dual/Keyboard+Mouse Receiver, Freedom Optical, Elite Duo,"
		elog "MX700/MX1000, Optical TrackMan, Click! Mouse, Presenter."
	fi
}

pkg_postrm() {
	udev_reload
}
