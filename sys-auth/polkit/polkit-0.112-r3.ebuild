# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/polkit/polkit-0.112-r3.ebuild,v 1.3 2015/07/05 18:01:37 ago Exp $

EAPI=5
inherit eutils multilib pam pax-utils systemd user

DESCRIPTION="Policy framework for controlling privileges for system-wide services"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/polkit"
SRC_URI="http://www.freedesktop.org/software/${PN}/releases/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE="examples gtk +introspection jit kde nls pam selinux systemd"

CDEPEND="
	ia64? ( =dev-lang/spidermonkey-1.8.5*[-debug] )
	hppa? ( =dev-lang/spidermonkey-1.8.5*[-debug] )
	mips? ( =dev-lang/spidermonkey-1.8.5*[-debug] )
	!hppa? ( !ia64? ( !mips? ( dev-lang/spidermonkey:17[-debug,jit=] ) ) )
	>=dev-libs/glib-2.32
	>=dev-libs/expat-2:=
	introspection? ( >=dev-libs/gobject-introspection-1 )
	pam? (
		sys-auth/pambase
		virtual/pam
		)
	systemd? ( sys-apps/systemd:0= )"
DEPEND="${CDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/intltool
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-policykit )
"
PDEPEND="
	gtk? ( || (
		>=gnome-extra/polkit-gnome-0.105
		lxde-base/lxpolkit
		) )
	kde? ( || (
		kde-plasma/polkit-kde-agent
		sys-auth/polkit-kde-agent
		) )
	!systemd? ( sys-auth/consolekit[policykit] )"

QA_MULTILIB_PATHS="
	usr/lib/polkit-1/polkit-agent-helper-1
	usr/lib/polkit-1/polkitd"

pkg_setup() {
	local u=polkitd
	local g=polkitd
	local h=/var/lib/polkit-1

	enewgroup ${g}
	enewuser ${u} -1 -1 ${h} ${g}
	esethome ${u} ${h}
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.112-0001-backend-Handle-invalid-object-paths-in-RegisterAuthe.patch" # bug 551316
	sed -i -e 's|unix-group:wheel|unix-user:0|' src/polkitbackend/*-default.rules || die #401513
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}"/var \
		--disable-static \
		--enable-man-pages \
		--disable-gtk-doc \
		$(use_enable systemd libsystemd-login) \
		$(use_enable introspection) \
		--disable-examples \
		$(use_enable nls) \
		$(if use hppa || use ia64 || use mips; then echo --with-mozjs=mozjs185; else echo --with-mozjs=mozjs-17.0; fi) \
		"$(systemd_with_unitdir)" \
		--with-authfw=$(usex pam pam shadow) \
		$(use pam && echo --with-pam-module-dir="$(getpam_mod_dir)") \
		--with-os-type=gentoo
}

src_compile() {
	default

	# Required for polkitd on hardened/PaX due to spidermonkey's JIT
	local f='src/polkitbackend/.libs/polkitd test/polkitbackend/.libs/polkitbackendjsauthoritytest'
	local m=''
	# Only used when USE="jit" is enabled for 'dev-lang/spidermonkey:17' wrt #485910
	has_version 'dev-lang/spidermonkey:17[jit]' && m='m'
	# hppa, ia64 and mips uses spidermonkey-1.8.5 which requires different pax-mark flags
	use hppa && m='mr'
	use ia64 && m='mr'
	use mips && m='mr'
	[ -n "$m" ] && pax-mark ${m} ${f}
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc docs/TODO HACKING NEWS README

	fowners -R polkitd:root /{etc,usr/share}/polkit-1/rules.d

	diropts -m0700 -o polkitd -g polkitd
	keepdir /var/lib/polkit-1

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins src/examples/{*.c,*.policy*}
	fi

	prune_libtool_files
}

pkg_postinst() {
	chown -R polkitd:root "${EROOT}"/{etc,usr/share}/polkit-1/rules.d
	chown -R polkitd:polkitd "${EROOT}"/var/lib/polkit-1
}
