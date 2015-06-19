# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/ezmlm-idx/ezmlm-idx-6.0.0.ebuild,v 1.12 2014/12/28 16:34:45 titanofold Exp $

EZMLM_P=ezmlm-0.53

inherit eutils fixheadtails

DESCRIPTION="Simple yet powerful mailing list manager for qmail"
HOMEPAGE="http://www.ezmlm.org"
SRC_URI="http://cr.yp.to/software/${EZMLM_P}.tar.gz
	http://www.ezmlm.org/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc sparc x86"
IUSE="mysql postgres"

DEPEND="
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
"
RDEPEND="${DEPEND}
	virtual/qmail"

S="${WORKDIR}"/${EZMLM_P}

pkg_setup() {
	if use mysql && use postgres; then
		die "cannot build mysql and pgsql support at the same time"
	fi
}

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/${P}/* "${S}" || die
	cd "${S}"

	epatch "${S}"/idx.patch

	ht_fix_file Makefile

	echo /usr/bin > conf-bin
	echo /usr/lib/ezmlm > conf-lib
	echo /etc/ezmlm > conf-etc
	echo /usr/share/man > conf-man
	echo /var/qmail > conf-qmail

	echo $(tc-getCC) ${CFLAGS} -I/usr/include/{my,postgre}sql > conf-cc
	echo $(tc-getCC) ${CFLAGS} > conf-ld

	# fix DESTDIR and skip cat man-pages
	sed -e "s:\(/install\) \(\"\`head\):\1 ${D}\2:" \
		-e "s:\(./install.*\) < MAN$:grep -v \:/cat MAN | \1:" \
		-e "s:\(\"\`head -n 1 conf-etc\`\"/default\):${D}\1:" \
		-i Makefile

	# ezmlm-mktab-{my|pg}sql may or may not be made
	sed -i -e "s/\(^.*mktab\)/?\1/" BIN
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
	dodir /usr/bin /usr/lib/ezmlm /etc/ezmlm /usr/share/man
	dobin ezmlm-cgi

	make DESTDIR="${D}" setup || die "make setup failed"
}
