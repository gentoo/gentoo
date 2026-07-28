# Copyright 2011-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{12..15} )
inherit meson python-any-r1 systemd vala

DESCRIPTION="D-Bus interfaces for querying and manipulating user account information"
HOMEPAGE="https://gitlab.freedesktop.org/accountsservice/accountsservice"
SRC_URI="https://gitlab.freedesktop.org/accountsservice/accountsservice/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="doc elogind gtk-doc +introspection selinux systemd test vala xcrypt"
RESTRICT="!test? ( test )"
REQUIRED_USE="^^ ( elogind systemd )"

CDEPEND="
	>=dev-libs/glib-2.70:2
	sys-auth/polkit
	>=dev-libs/json-c-0.15
	virtual/libcrypt:=
	elogind? ( >=sys-auth/elogind-229.4 )
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
	systemd? ( >=sys-apps/systemd-186:0= )
	xcrypt? ( sys-libs/libxcrypt )
"
DEPEND="${CDEPEND}
	sys-apps/dbus
"
BDEPEND="
	dev-libs/libxslt
	>=dev-util/gdbus-codegen-2.80.5-r1
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto
	)
	gtk-doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3
	)
	vala? ( $(vala_depend) )
	test? (
		$(python_gen_any_dep '
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-accountsd )
"

PATCHES=(
	"${FILESDIR}"/${PN}-22.04.62-gentoo-system-users.patch
	"${FILESDIR}"/${PN}-23.13.9-test-languages.patch #903347
)

python_check_deps() {
	if use test; then
		python_has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
	fi
}

src_prepare() {
	default

	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		--localstatedir="${EPREFIX}/var"
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Dadmin_group="wheel"
		-Dcreate_homed=false
		$(meson_use elogind)
		$(meson_use introspection)
		$(meson_use doc docbook)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use test tests)
		$(meson_use vala vapi)
		$(meson_use xcrypt libxcrypt)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# https://gitlab.freedesktop.org/accountsservice/accountsservice/-/issues/90
	if use doc; then
		mv "${ED}/usr/share/doc/${PN}" "${ED}/usr/share/doc/${PF}" || die
	fi

	# This directories are created at runtime when needed
	rm -r "${ED}"/var/lib || die

	newinitd "${FILESDIR}"/accounts-daemon.initd accounts-daemon
}
