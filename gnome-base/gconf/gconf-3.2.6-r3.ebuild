# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"
GNOME_ORG_MODULE="GConf"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit eutils gnome2 multilib-minimal python-r1

DESCRIPTION="GNOME configuration system and daemon"
HOMEPAGE="https://projects.gnome.org/gconf/"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
IUSE="debug +introspection ldap policykit"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=dev-libs/dbus-glib-0.100.2:=[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1.6.18-r1:=[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	ldap? ( >=net-nds/openldap-2.4.38-r1:=[${MULTILIB_USEDEP}] )
	policykit? ( sys-auth/polkit:= )
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"
RDEPEND="${RDEPEND}
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-gtklibs-20140508-r1
		!app-emulation/emul-linux-x86-gtklibs[-abi_x86_32(-)]
	)"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_setup() {
	kill_gconf
}

src_prepare() {
	# Do not start gconfd when installing schemas, fix bug #238276, upstream #631983
	epatch "${FILESDIR}/${PN}-2.24.0-no-gconfd.patch"

	# Do not crash in gconf_entry_set_value() when entry pointer is NULL, upstream #631985
	epatch "${FILESDIR}/${PN}-2.28.0-entry-set-value-sigsegv.patch"

	# From 'master'
	# mconvert: enable recursive scheme lookup and fix a crasher
	epatch "${FILESDIR}/${P}-mconvert-crasher.patch"

	# dbus: Don't spew to console when unable to connect to dbus daemon
	epatch "${FILESDIR}/${P}-spew-console-error.patch"

	# gsettings-data-convert: Warn (and fix) invalid schema paths
	epatch "${FILESDIR}/${P}-gsettings-data-convert-paths.patch"

	gnome2_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-static \
		--enable-gsettings-backend \
		--with-gtk=3.0 \
		--disable-orbit \
		$(multilib_native_use_enable introspection) \
		$(use_with ldap openldap) \
		$(multilib_native_use_enable policykit defaults-service)

	if multilib_is_native_abi; then
		ln -s "${S}"/doc/gconf/html doc/gconf/html || die
	fi
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	python_replicate_script "${ED}"/usr/bin/gsettings-schema-convert

	keepdir /etc/gconf/gconf.xml.mandatory
	keepdir /etc/gconf/gconf.xml.defaults
	# Make sure this directory exists, bug #268070, upstream #572027
	keepdir /etc/gconf/gconf.xml.system

	echo "CONFIG_PROTECT_MASK=\"/etc/gconf\"" > 50gconf
	echo 'GSETTINGS_BACKEND="gconf"' >> 50gconf
	doenvd 50gconf
	dodir /root/.gconfd
}

pkg_preinst() {
	kill_gconf
}

pkg_postinst() {
	kill_gconf

	# change the permissions to avoid some gconf bugs
	einfo "changing permissions for gconf dirs"
	find  "${EPREFIX}"/etc/gconf/ -type d -exec chmod ugo+rx "{}" \;

	einfo "changing permissions for gconf files"
	find  "${EPREFIX}"/etc/gconf/ -type f -exec chmod ugo+r "{}" \;
}

kill_gconf() {
	# This function will kill all running gconfd-2 that could be causing troubles
	if [ -x "${EPREFIX}"/usr/bin/gconftool-2 ]
	then
		"${EPREFIX}"/usr/bin/gconftool-2 --shutdown
	fi

	return 0
}
