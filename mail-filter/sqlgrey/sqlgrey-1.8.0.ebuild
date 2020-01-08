# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="A postfix policy service implementing a grey-listing policy"
HOMEPAGE="http://sqlgrey.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/sqlgrey/sqlgrey-1.8%20%28stable%29/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~sparc ~x86"
IUSE="mysql postgres +sqlite"
REQUIRED_USE="|| ( mysql postgres sqlite )"

RDEPEND="acct-user/sqlgrey
	dev-lang/perl
	dev-perl/DBI
	dev-perl/Date-Calc
	dev-perl/Net-Server
	virtual/mailx
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	sqlite? ( dev-perl/DBD-SQLite )"
DEPEND="${RDEPEND}
	sys-apps/sed"

DOCS=( HOWTO FAQ README README.OPTINOUT README.PERF TODO Changelog )
PATCHES=(
	"${FILESDIR}/sqlgrey-1.8.0-init-openrc.patch"
)

src_install () {
	emake gentoo-install ROOTDIR="${D}"
	einstalldocs

	systemd_dounit "${FILESDIR}/${PN}.service"
}

pkg_postinst() {
	elog "To make use of greylisting, please update your postfix config."
	elog
	elog "Put something like this in ${ROOT}/etc/postfix/main.cf:"
	elog "    smtpd_recipient_restrictions ="
	elog "           ..."
	elog "           check_policy_service inet:127.0.0.1:2501"
	elog
	elog "Remember to restart Postfix after that change. Also remember"
	elog "to make the daemon start durig boot:"
	elog "  rc-update add sqlgrey default"
	elog
	ewarn "Read the documentation for more info (perldoc sqlgrey) or the"
	ewarn "included HOWTO in ${ROOT}/usr/share/doc/${PF}/"
	ewarn
	ewarn "If you are using MySQL >= 4.1 use \"latin1\" as charset for"
	ewarn "the SQLgrey db"
}
