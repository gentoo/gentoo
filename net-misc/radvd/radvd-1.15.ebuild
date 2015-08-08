# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit systemd user eutils

DESCRIPTION="Linux IPv6 Router Advertisement Daemon"
HOMEPAGE="http://v6web.litech.org/radvd/"
SRC_URI="http://v6web.litech.org/radvd/dist/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="kernel_FreeBSD selinux"

CDEPEND="dev-libs/libdaemon"
DEPEND="${CDEPEND}
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-radvd )
"

DOCS=( CHANGES-1 README TODO radvd.conf.example )

pkg_setup() {
	enewgroup radvd
	enewuser radvd -1 -1 /dev/null radvd

	# force ownership of radvd user and group (bug #19647)
	[[ -d ${ROOT}/var/run/radvd ]] && chown radvd:radvd "${ROOT}"/var/run/radvd
}

src_configure() {
	econf --with-pidfile=/var/run/radvd/radvd.pid \
		--disable-silent-rules
}

src_install() {
	default

	dohtml INTRO.html

	newinitd "${FILESDIR}"/${PN}-1.9.1.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}

	systemd_dounit "${FILESDIR}"/${PN}.service

	if use kernel_FreeBSD ; then
		sed -i -e \
			's/^SYSCTL_FORWARD=.*$/SYSCTL_FORWARD=net.inet6.ip6.forwarding/g' \
			"${D}"/etc/init.d/${PN} || die
	fi
}

pkg_postinst() {
	einfo
	elog "Please create a configuratoion ${ROOT}etc/radvd.conf."
	elog "See ${ROOT}usr/share/doc/${PF} for an example."
	einfo
	elog "grsecurity users should allow a specific group to read /proc"
	elog "and add the radvd user to that group, otherwise radvd may"
	elog "segfault on startup."
}
