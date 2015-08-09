# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes" # Not gnome macro but similar
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit fcaps gnome2 pam python-any-r1 versionator virtualx

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeKeyring"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+caps debug pam selinux +ssh-agent"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x86-solaris"

RDEPEND="
	>=app-crypt/gcr-3.5.3:=[gtk]
	>=dev-libs/glib-2.38:2
	app-misc/ca-certificates
	>=dev-libs/libgcrypt-1.2.2:0=
	>=sys-apps/dbus-1.1.1
	caps? ( sys-libs/libcap-ng )
	pam? ( virtual/pam )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	app-text/docbook-xml-dtd:4.3
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	# Disable stupid CFLAGS
	sed -e 's/CFLAGS="$CFLAGS -g"//' \
		-e 's/CFLAGS="$CFLAGS -O0"//' \
		-i configure.ac configure || die

	# FIXME: some tests write to /tmp (instead of TMPDIR)
	# Disable failing tests
	sed -e 's|\(g_test_add.*/gkm/data-asn1/integers.*;\)|/*\1*/|' \
		-i "${S}"/pkcs11/gkm/test-data-asn1.c || die
	sed -e 's|\(g_test_add.*/gkm/timer/cancel.*;\)|/*\1*/|' \
		-i "${S}"/pkcs11/gkm/test-timer.c || die
	# For some reason all pam tests make the testsuite retun 77
	# which is considered an error but the test framework,
	# but all tests are successful, upstream bug #731030
	sed -e '558,595 d' -i "${S}"/pam/test-pam.c || die

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_with caps libcap-ng) \
		$(use_enable pam) \
		$(use_with pam pam-dir $(getpam_mod_dir)) \
		$(use_enable selinux) \
		$(use_enable ssh-agent) \
		--enable-doc \
		--enable-gpg-agent
}

src_test() {
	 # FIXME: this should be handled at eclass level
	 "${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/schema" || die

	 unset DBUS_SESSION_BUS_ADDRESS
	 GSETTINGS_SCHEMA_DIR="${S}/schema" Xemake check
}

pkg_postinst() {
	# cap_ipc_lock only needed if building --with-libcap-ng
	# Never install as suid root, this breaks dbus activation, see bug #513870
	use caps && fcaps -m 755 cap_ipc_lock usr/bin/gnome-keyring-daemon
	gnome2_pkg_postinst
}
