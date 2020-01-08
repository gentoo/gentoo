# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Rate-limited autoresponder for qmail"
HOMEPAGE="http://untroubled.org/qmail-autoresponder/"
SRC_URI="http://untroubled.org/qmail-autoresponder/archive/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 hppa ~mips ppc ~sparc x86"
IUSE="mysql"

DEPEND=">=dev-libs/bglibs-1.106
	mysql? ( dev-db/mysql-connector-c:0= )"
RDEPEND="
	${DEPEND}
	virtual/qmail
	mysql? ( virtual/mysql )
"

src_prepare() {
	use mysql || eapply "${FILESDIR}/${PN}-0.97-remove-mysql.h.diff"
	default
}

src_configure() {
	echo "/usr/include/bglibs" > conf-bgincs || die
	echo "/usr/$(get_libdir)/bglibs" > conf-bglibs || die
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
}

src_compile() {
	# fails on parallel builds!
	make qmail-autoresponder || die "Failed to make qmail-autoresponder"
	if use mysql; then
		make qmail-autoresponder-mysql || die "Failed to make qmail-autoresponder-mysql"
	fi
}

src_install () {
	dobin qmail-autoresponder
	doman qmail-autoresponder.1
	if use mysql; then
		dobin qmail-autoresponder-mysql
		dodoc schema.mysql
	fi

	dodoc ANNOUNCEMENT NEWS README TODO ChangeLog procedure.txt
}

pkg_postinst() {
	elog "Please see the README file in /usr/share/doc/${PF}/ for per-user configurations."
}
