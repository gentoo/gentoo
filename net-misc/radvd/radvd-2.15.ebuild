# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit systemd user eutils readme.gentoo-r1

DESCRIPTION="Linux IPv6 Router Advertisement Daemon"
HOMEPAGE="http://v6web.litech.org/radvd/"
SRC_URI="http://v6web.litech.org/radvd/dist/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="kernel_FreeBSD selinux test"

CDEPEND="dev-libs/libdaemon"
DEPEND="${CDEPEND}
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	test? ( dev-libs/check )"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-radvd )
"
DOCS=( CHANGES README TODO radvd.conf.example )

pkg_setup() {
	enewgroup radvd
	enewuser radvd -1 -1 /dev/null radvd

	# force ownership of radvd user and group (bug #19647)
	[[ -d ${ROOT}/var/run/radvd ]] && chown radvd:radvd "${ROOT}"/var/run/radvd
}

src_configure() {
	econf --with-pidfile=/var/run/radvd/radvd.pid \
		--disable-silent-rules \
		--with-systemdsystemunitdir=no \
		$(use_with test check)
}

src_install() {
	default

	dohtml INTRO.html

	newinitd "${FILESDIR}"/${PN}-1.9.1.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}

	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_newtmpfilesd  "${FILESDIR}"/${PN}.tmpfilesd ${PN}.conf

	if use kernel_FreeBSD ; then
		sed -i -e \
			's/^SYSCTL_FORWARD=.*$/SYSCTL_FORWARD=net.inet6.ip6.forwarding/g' \
			"${D}"/etc/init.d/${PN} || die
	fi

	readme.gentoo_create_doc
}

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="Please create a configuration file ${ROOT}etc/radvd.conf.
See ${ROOT}usr/share/doc/${PF} for an example.

grsecurity users should allow a specific group to read /proc
and add the radvd user to that group, otherwise radvd may
segfault on startup."
