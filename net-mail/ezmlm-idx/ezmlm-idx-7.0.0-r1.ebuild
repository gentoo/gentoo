# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/ezmlm-idx/ezmlm-idx-7.0.0-r1.ebuild,v 1.4 2014/12/28 16:34:45 titanofold Exp $

inherit qmail multilib

DESCRIPTION="Simple yet powerful mailing list manager for qmail"
HOMEPAGE="http://www.ezmlm.org"
SRC_URI="http://www.ezmlm.org/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="mysql postgres"

DEPEND="mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )"
RDEPEND="${DEPEND}
	virtual/qmail"

pkg_setup() {
	if use mysql && use postgres; then
		die "cannot build mysql and pgsql support at the same time"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}" || die

	echo /usr/bin > conf-bin
	echo /usr/$(get_libdir)/ezmlm > conf-lib
	echo /etc/ezmlm > conf-etc
	echo /usr/share/man > conf-man
	echo ${QMAIL_HOME} > conf-qmail

	echo $(tc-getCC) ${CFLAGS} -I/usr/include/{my,postgre}sql > conf-cc
	echo $(tc-getCC) ${CFLAGS} -Wl,-E > conf-ld

	# fix DESTDIR and skip cat man-pages
	sed -e "s:\(/install\) \(\"\`head\):\1 ${D}\2:" \
		-e "s:\(./install.*\) < MAN$:grep -v \:/cat MAN | \1:" \
		-e "s:\(\"\`head -n 1 conf-etc\`\"/default\):${D}\1:" \
		-i Makefile
}

src_compile() {
	emake it man || die "make failed"

	if use mysql; then
		emake mysql || die "make mysql failed"
	elif use postgres; then
		emake pgsql || die "make pgsql failed"
	fi
}

src_install () {
	dodir /usr/bin /usr/$(get_libdir)/ezmlm /etc/ezmlm /usr/share/man
	dobin ezmlm-{cgi,checksub}

	make DESTDIR="${D}" setup || die "make setup failed"
}
