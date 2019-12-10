# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit fcaps gnome2 pam python-any-r1 virtualx

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeKeyring"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+caps pam selinux +ssh-agent test"
RESTRICT="!test? ( test )"
KEYWORDS="alpha amd64 arm arm64 ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"

# Replace gkd gpg-agent with pinentry[gnome-keyring] one, bug #547456
RDEPEND="
	>=app-crypt/gcr-3.27.90:=[gtk]
	>=dev-libs/glib-2.44:2
	app-misc/ca-certificates
	>=dev-libs/libgcrypt-1.2.2:0=
	caps? ( sys-libs/libcap-ng )
	pam? ( sys-libs/pam )
	selinux? ( sec-policy/selinux-gnome )
	>=app-crypt/gnupg-2.0.28:=
	ssh-agent? ( net-misc/openssh )
"
DEPEND="${RDEPEND}
	>=app-eselect/eselect-pinentry-0.5
	app-text/docbook-xml-dtd:4.3
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
"
PDEPEND="app-crypt/pinentry[gnome-keyring]" #570512

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	# Disable stupid CFLAGS with debug enabled
	sed -e 's/CFLAGS="$CFLAGS -g"//' \
		-e 's/CFLAGS="$CFLAGS -O0"//' \
		-i configure.ac configure || die

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_with caps libcap-ng) \
		$(use_enable pam) \
		$(use_with pam pam-dir $(getpam_mod_dir)) \
		$(use_enable selinux) \
		$(use_enable ssh-agent) \
		--enable-doc
}

src_test() {
	 "${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/schema" || die
	 GSETTINGS_SCHEMA_DIR="${S}/schema" virtx emake check
}

pkg_postinst() {
	# cap_ipc_lock only needed if building --with-libcap-ng
	# Never install as suid root, this breaks dbus activation, see bug #513870
	use caps && fcaps -m 755 cap_ipc_lock usr/bin/gnome-keyring-daemon
	gnome2_pkg_postinst

	if ! [[ $(eselect pinentry show | grep "pinentry-gnome3") ]] ; then
		ewarn "Please select pinentry-gnome3 as default pinentry provider:"
		ewarn " # eselect pinentry set pinentry-gnome3"
	fi
}
