# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs user

DESCRIPTION="A milter-based regular expression filter"
HOMEPAGE="https://www.benzedrine.ch/milter-regex.html"
SRC_URI="https://www.benzedrine.ch/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="|| ( mail-filter/libmilter mail-mta/sendmail )"
DEPEND="${RDEPEND}
	virtual/yacc"

PATCHES=( "${FILESDIR}/${P}-gentoo.patch" )

src_compile() {
	emake CC="$(tc-getCC)" -f Makefile.linux all
}

src_install() {
	dobin ${PN}

	insinto /etc
	newins rules ${PN}.conf

	newconfd "${FILESDIR}/${PN}-conf-${PV}" ${PN}
	newinitd "${FILESDIR}/${PN}-init-${PV}" ${PN}

	doman *.8
}

pkg_preinst() {
	# For consistency with mail-milter/spamass-milter (see bug #280571).
	# While the milter process requires an owner, a home directory is not
	# necessary because no data is written.
	enewgroup milter
	enewuser milter -1 -1 /var/lib/milter milter
}

pkg_postinst() {
	elog "Postfix configuration example (add to main.cf or master.cf):"
	elog "  smtpd_milters=unix:/run/milter-regex/socket"
	elog "Sendmail configuration example:"
	elog "  INPUT_MAIL_FILTER(\`${PN}',\`S=unix:/run/milter-regex/socket,T=S:30s;R:2m')"
}
