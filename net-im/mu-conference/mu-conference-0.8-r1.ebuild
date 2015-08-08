# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Multi-User Chat for jabberd"
HOMEPAGE="https://gna.org/projects/mu-conference/"
SRC_URI="http://download.gna.org/mu-conference/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
SLOT="0"
IUSE="mysql"

RDEPEND="
	dev-libs/expat
	>=dev-libs/glib-2:2
	net-dns/libidn
	net-im/jabberd2
	mysql? ( virtual/mysql )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}_${PV}

src_prepare() {
	# Fix missing header in src/conference_user.c in order to
	# make emerge happy and avoid QA notice.
	sed -i -e "/conference.h/ i #define _XOPEN_SOURCE" src/conference_user.c || die

	if use mysql; then
		sed -i -e '/^CFLAGS/ a CFLAGS:=$(CFLAGS) -DHAVE_MYSQL' \
			-e '/^LIBS/ a LIBS:=$(LIBS) `mysql_config --libs`' src/Makefile || die
	fi
		sed -i -e 's/^CC:=/CC?=/' -e 's/$(MCFLAGS)/$(MCFLAGS) $(LDFLAGS)/'\
			-e 's/LDFLAGS:=-L./LDFLAGS:=$(LDFLAGS) -L./'\
			-e 's/$(LDFLAGS) $(LIBS)/$(LIBS)/' src/Makefile || die
		sed -i -e 's/-O2//' src/{,jabberd,jcomp}/Makefile || die
		sed -i -e 's/CC=/CC?=/' src/{jabberd,jcomp}/Makefile || die
		sed -i -e 's/ar/$(AR)/' -e 's/ranlib/$(RANLIB)/' src/jabberd/Makefile || die
		sed -i -e 's/gcc -g/$(CC) -g/' src/jcomp/Makefile || die
	tc-export CC AR RANLIB
}

src_install() {
	dobin src/mu-conference
	fowners jabber:jabber /usr/bin/mu-conference
	fperms 750 /usr/bin/mu-conference

	newinitd "${FILESDIR}/${PN}"-0.7.init mu-conference

	dodoc ChangeLog FAQ mu-conference.sql README README.sql
	docinto scripts
	dodoc scripts/*

	local i
	for i in log spool; do
		dodir /var/${i}/jabber/mu-conference
		keepdir /var/${i}/jabber/mu-conference
		fowners jabber:jabber /var/${i}/jabber/mu-conference
		fperms 770 /var/${i}/jabber/mu-conference
	done

	insinto /etc/jabber
	newins muc-default.xml mu-conference.xml
	doins style.css

	sed -i \
		-e 's,./spool/chat.localhost,/var/spool/jabber/mu-conference,g' \
		-e 's,./syslogs,/var/log/jabber,g' \
		-e 's,./logs,/var/log/jabber/mu-conference,g' \
		-e 's,./mu-conference.pid,/var/run/jabber/mu-conference.pid,g' \
		-e "s,../style.css,/etc/jabber/style.css,g" \
		-e "s,7009,5347,g" \
		"${D}"/etc/jabber/mu-conference.xml || die "sed failed"
}

pkg_postinst() {
	echo
	elog "For jabberd-2 connection:"
	elog "1. Make sure that the ip and port in /etc/jabber/mu-conference.xml"
	elog "   match the address of your jabberd router."
	elog "2. Set a common secret in mu-conference.xml and router.xml"
	echo
}
