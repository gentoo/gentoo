# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..13} )

inherit gnome.org gnome2-utils meson python-any-r1 virtualx xdg

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-keyring"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="pam selinux ssh-agent systemd test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.80:2
	>=app-crypt/gcr-3.27.90:0=[gtk]
	>=dev-libs/libgcrypt-1.2.2:0=
	app-crypt/p11-kit

	>=app-eselect/eselect-pinentry-0.5
	app-misc/ca-certificates

	selinux? ( sec-policy/selinux-gnome )
	systemd? ( sys-apps/systemd )
	ssh-agent? ( virtual/openssh )
	pam? ( sys-libs/pam )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	>=app-eselect/eselect-pinentry-0.5
	app-text/docbook-xml-dtd:4.3
	dev-libs/libxslt
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
"

PATCHES=(
	# From Fedora:
	# https://gitlab.gnome.org/GNOME/gnome-keyring/-/merge_requests/96
	"${FILESDIR}/${PN}-48.0-collection-registering.patch"

	#https://gitlab.gnome.org/GNOME/gnome-keyring/-/issues/151
	"${FILESDIR}/${PN}-48.0-gkm_marshal-header.patch"
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use ssh-agent)
		$(meson_feature selinux)
		$(meson_feature systemd)
		$(meson_use pam)
	)
	meson_src_configure
}

src_test() {
	# Needs dbus-run-session to not get:
	# ERROR: test-dbus-search process failed: -6
	"${BROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/schema" || die
	GSETTINGS_SCHEMA_DIR="${S}/schema" virtx dbus-run-session meson test -C "${BUILD_DIR}" || die
}

pkg_postinst() {
	# cap_ipc_lock only needed if building with libcap-ng, but that breaks with glib-2.70
	# Never install as suid root, this breaks dbus activation, see bug
	# #513870, https://gitlab.gnome.org/GNOME/gnome-keyring/-/issues/77

	xdg_pkg_postinst
	gnome2_schemas_update
	if ! [[ $(eselect pinentry show | grep "pinentry-gnome3") ]] ; then
		ewarn "Please select pinentry-gnome3 as default pinentry provider:"
		ewarn " # eselect pinentry set pinentry-gnome3"
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
