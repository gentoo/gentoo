# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmail toolchain-funcs

DESCRIPTION="Simple yet powerful mailing list manager for qmail"
HOMEPAGE="http://www.ezmlm.org"
SRC_URI="http://www.ezmlm.org/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~mips ppc sparc x86"
IUSE="mysql postgres"

DEPEND="mysql? ( dev-db/mysql-connector-c:0= )
	postgres? ( dev-db/postgresql )"
RDEPEND="${DEPEND}
	virtual/qmail"
REQUIRED_USE="?? ( mysql postgres )"

src_prepare() {
	default
	echo /usr/bin > conf-bin || die
	echo /usr/$(get_libdir)/ezmlm > conf-lib || die
	echo /etc/ezmlm > conf-etc || die
	echo /usr/share/man > conf-man || die
	echo ${QMAIL_HOME} > conf-qmail || die

	echo $(tc-getCC) ${CFLAGS} -I/usr/include/{my,postgre}sql > conf-cc || die
	echo $(tc-getCC) ${CFLAGS} -Wl,-E > conf-ld || die

	# fix DESTDIR and skip cat man-pages
	sed -e "s:\(/install\) \(\"\`head\):\1 ${D}\2:" \
		-e "s:\(./install.*\) < MAN$:grep -v \:/cat MAN | \1:" \
		-e "s:\(\"\`head -n 1 conf-etc\`\"/default\):${D}\1:" \
		-i Makefile || die
}

src_compile() {
	emake it man

	if use mysql; then
		emake mysql
	elif use postgres; then
		emake pgsql
	fi
}

src_install () {
	dodir /usr/bin /usr/$(get_libdir)/ezmlm /etc/ezmlm /usr/share/man
	dobin ezmlm-{cgi,checksub,import,rmtab}

	make DESTDIR="${D}" setup || die "make setup failed"
}
