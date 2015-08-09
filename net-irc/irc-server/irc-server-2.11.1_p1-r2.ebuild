# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils versionator flag-o-matic user

MY_P=irc${PV/_/}

DESCRIPTION="RFC compliant IRC server"
HOMEPAGE="http://www.irc.org/"
SRC_URI="ftp://ftp.irc.org/irc/server/${MY_P}.tgz
	ftp://ftp.irc.org/irc/server/Old/irc$(get_version_component_range 1-2)/${MY_P}.tgz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="zlib ipv6"

RDEPEND="sys-libs/ncurses
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	sys-apps/sed
	sys-apps/grep"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup ircd
	enewuser ircd -1 -1 -1 ircd
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/2.10.3_p3-gentoo.patch
}

src_compile () {
	sed -i \
		-e "s/^#undef\tOPER_KILL$/#define\tOPER_KILL/" \
		-e "s/^#undef\tOPER_RESTART$/#define\tOPER_RESTART/" \
		-e "s/^#undef TIMEDKLINES$/#define\tTIMEDKLINES\t60/" \
		-e "s/^#undef\tR_LINES$/#define\tR_LINES/" \
		-e "s/^#undef\tCRYPT_OPER_PASSWORD$/#define\tCRYPT_OPER_PASSWORD/" \
		-e "s/^#undef\tCRYPT_LINK_PASSWORD$/#define\tCRYPT_LINK_PASSWORD/" \
		-e "s/^#undef\tIRC_UID$/#define\tIRC_UID\t$IRCUID/" \
		-e "s/^#undef\tIRC_GID$/#define\tIRC_GID\t$IRCGID/" \
		-e "s/^#undef USE_SERVICES$/#define\tUSE_SERVICES/" \
		"${S}"/support/config.h.dist

	use zlib && sed -i -e "s/^#undef\tZIP_LINKS$/#define\tZIP_LINKS/" "${S}"/support/config.h.dist

	econf \
		--sysconfdir=/etc/ircd \
		--localstatedir=/var/run/ircd \
		--with-logdir=/var/log/ircd \
		--with-rundir=/var/run/ircd \
		--mandir='${prefix}/share/man' \
		$(use_with zlib) \
		$(use_enable ipv6 ip6) \
		|| die "econf failed"

	cd $(support/config.guess)
	emake ircd iauth chkconf ircd-mkpasswd ircdwatch tkserv || die "emake failed"
}

src_install() {
	cd $(support/config.guess)

	emake \
		prefix=${D}/usr \
		ircd_conf_dir=${D}/etc/ircd \
		ircd_var_dir=${D}/var/run/ircd \
		ircd_log_dir=${D}/var/log/ircd \
		install-server \
		install-tkserv \
		|| die "make install failed"

	fowners ircd:ircd /var/run/ircd
	fowners ircd:ircd /var/log/ircd

	cd ../doc
	dodoc \
		*-New alt-irc-faq Authors BUGS ChangeLog Etiquette \
		iauth-internals.txt INSTALL.appendix INSTALL.* LICENSE \
		m4macros README RELEASE* rfc* SERVICE*

	docinto Juped
	dodoc Juped/Advertisement Juped/ChangeLog.* Juped/INSTALL

	docinto Juped/US-Admin
	dodoc Juped/US-Admin/Networking

	docinto Nets
	dodoc Nets/IRCNet

	docinto Nets/Europe
	dodoc Nets/Europe/*

	newinitd "${FILESDIR}"/ircd.rc ircd
	newconfd "${FILESDIR}"/ircd.confd ircd
}
