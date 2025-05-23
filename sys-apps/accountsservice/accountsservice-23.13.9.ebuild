# Copyright 2011-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )
inherit meson python-any-r1 systemd vala

DESCRIPTION="D-Bus interfaces for querying and manipulating user account information"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/AccountsService/"
SRC_URI="https://www.freedesktop.org/software/${PN}/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86"

IUSE="doc elogind gtk-doc +introspection selinux systemd test vala"
RESTRICT="!test? ( test )"
REQUIRED_USE="^^ ( elogind systemd )"

CDEPEND="
	>=dev-libs/glib-2.63.5:2
	sys-auth/polkit
	virtual/libcrypt:=
	elogind? ( >=sys-auth/elogind-229.4 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
	systemd? ( >=sys-apps/systemd-186:0= )
"
DEPEND="${CDEPEND}
	sys-apps/dbus
"
BDEPEND="
	dev-libs/libxslt
	dev-util/gdbus-codegen
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
	"${FILESDIR}"/${PN}-23.13.9-generate-version.patch #905770
	# From Alpine Linux
	# https://gitlab.freedesktop.org/accountsservice/accountsservice/-/merge_requests/97
	"${FILESDIR}"/${PN}-23.13.9-musl-fixes.patch
	"${FILESDIR}"/${PN}-23.13.9-c99-fixes.patch #930715
	"${FILESDIR}"/${PN}-23.13.9-test-fix.patch
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
	# No option to disable tests
	if ! use test; then
		sed -e "/subdir('tests')/d" -i meson.build || die
	fi

	local emesonargs=(
		--localstatedir="${EPREFIX}/var"
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Dadmin_group="wheel"
		$(meson_use elogind)
		$(meson_use introspection)
		$(meson_use doc docbook)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use vala vapi)
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
}
