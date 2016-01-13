# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils linux-info pam

MY_PN=ConsoleKit2
MY_P=${MY_PN}-${PV}

DESCRIPTION="Framework for defining and tracking users, login sessions and seats"
HOMEPAGE="https://github.com/ConsoleKit2/ConsoleKit2 http://www.freedesktop.org/wiki/Software/ConsoleKit"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/releases/download/${PV}/${MY_P}.tar.bz2
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_0.4.6-4.debian.tar.gz" # for logrotate file"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~amd64-fbsd ~amd64-linux ~arm ~hppa ~ia64-linux ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~x86-linux"
IUSE="acl cgroups debug doc kernel_linux pam policykit selinux test"

COMMON_DEPEND=">=dev-libs/glib-2.40:2=[dbus]
	>=sys-devel/gettext-0.19
	sys-apps/dbus
	sys-libs/zlib:=
	x11-libs/libX11:=
	acl? (
		sys-apps/acl:=
		>=virtual/udev-200
		)
	cgroups? (
		app-admin/cgmanager
		>=sys-libs/libnih-1.0.2[dbus]
		)
	pam? ( virtual/pam )
	policykit? ( >=sys-auth/polkit-0.110 )"
RDEPEND="${COMMON_DEPEND}
	kernel_linux? ( sys-apps/coreutils[acl?] )
	selinux? ( sec-policy/selinux-consolekit )"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	virtual/pkgconfig
	doc? ( app-text/xmlto )
	test? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto
		)"

S=${WORKDIR}/${MY_P}

QA_MULTILIB_PATHS="usr/lib/ConsoleKit/.*"

pkg_setup() {
	if use kernel_linux; then
		# This is from https://bugs.gentoo.org/376939
		use acl && CONFIG_CHECK="~TMPFS_POSIX_ACL"
		# This is required to get login-session-id string with pam_ck_connector.so
		use pam && CONFIG_CHECK+=" ~AUDITSYSCALL"
		linux-info_pkg_setup
	fi
}

src_prepare() {
	sed -i -e '/SystemdService/d' data/org.freedesktop.ConsoleKit.service.in || die

	epatch_user
}

src_configure() {
	econf \
		XMLTO_FLAGS='--skip-validation' \
		--libexecdir="${EPREFIX}"/usr/lib/ConsoleKit \
		--localstatedir="${EPREFIX}"/var \
		$(use_enable pam pam-module) \
		$(use_enable doc docbook-docs) \
		$(use_enable test docbook-docs) \
		$(use_enable debug) \
		$(use_enable policykit polkit) \
		$(use_enable acl udev-acl) \
		$(use_enable cgroups) \
		$(use_enable test tests) \
		--with-dbus-services="${EPREFIX}"/usr/share/dbus-1/services \
		--with-pam-module-dir="$(getpam_mod_dir)" \
		--with-xinitrc-dir=/etc/X11/xinit/xinitrc.d \
		--without-systemdsystemunitdir
}

src_install() {
	emake \
		DESTDIR="${D}" \
		htmldocdir="${EPREFIX}"/usr/share/doc/${PF}/html \
		install

	dosym /usr/lib/ConsoleKit /usr/lib/${PN}

	dodoc AUTHORS HACKING NEWS README TODO

	newinitd "${FILESDIR}"/${PN}-1.0.0.initd consolekit

	keepdir /usr/lib/ConsoleKit/run-seat.d
	keepdir /usr/lib/ConsoleKit/run-session.d
	keepdir /etc/ConsoleKit/run-session.d
	keepdir /var/log/ConsoleKit

	exeinto /etc/X11/xinit/xinitrc.d
	newexe "${FILESDIR}"/90-consolekit-3 90-consolekit

	if use kernel_linux; then
		exeinto /usr/lib/ConsoleKit/run-session.d
		doexe "${FILESDIR}"/pam-foreground-compat.ck
	fi

	prune_libtool_files --all # --all for pam_ck_connector.la

	rm -rf "${ED}"/var/run || die # let the init script create the directory

	insinto /etc/logrotate.d
	newins "${WORKDIR}"/debian/${PN}.logrotate ${PN} #374513
}

pkg_postinst() {
	elog "For suspend/hibernate support, please emerge"
	elog "  sys-power/pm-utils"
}
