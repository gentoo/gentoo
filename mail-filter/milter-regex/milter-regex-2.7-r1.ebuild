# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A milter-based regular expression filter"
HOMEPAGE="https://www.benzedrine.ch/milter-regex.html"
SRC_URI="https://www.benzedrine.ch/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="acct-user/milter-regex
	>=mail-filter/libmilter-1.0.2_p2:="
DEPEND="${RDEPEND}
	virtual/yacc"

src_prepare() {
	eapply "${FILESDIR}/${PN}-2.6-gentoo.patch"
	eapply_user
	# Change default user
	sed -i -e 's/_\(milter-regex\)/\1/g' ${PN}.[8c] || die
}

src_compile() {
	emake CC="$(tc-getCC)" -f Makefile.linux all
}

src_install() {
	dobin ${PN}
	insinto /etc
	newins rules ${PN}.conf
	newconfd "${FILESDIR}/${PN}-conf-2.6" ${PN}
	newinitd "${FILESDIR}/${PN}-init" ${PN}
	doman *.8
}

pkg_postinst() {
	elog "Postfix configuration example (add to main.cf or master.cf):"
	elog "  smtpd_milters=unix:/run/milter-regex/socket"
	elog "Sendmail configuration example:"
	elog "  INPUT_MAIL_FILTER(\`${PN}',\`S=unix:/run/milter-regex/socket,T=S:30s;R:2m')"
}
