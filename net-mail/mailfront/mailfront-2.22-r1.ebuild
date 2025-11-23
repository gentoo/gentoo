# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Mail server network protocol front-ends"
HOMEPAGE="https://untroubled.org/mailfront/"
SRC_URI="https://untroubled.org/mailfront/archive/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

DEPEND=">=dev-libs/bglibs-2.04
	>=net-libs/cvm-0.81"
RDEPEND="${DEPEND}
	virtual/qmail
	net-libs/cvm"

src_prepare() {
	default
	local sed_args=(
		# make compilation more verbose
		-e '/exec/ {h;s/exec/echo/g;G}'
		# replace AR and be more verbose, bug #792249
		-e "/ar cr/ {h;s/ar/echo &/;G;s:ar:$(tc-getAR):g}"
		# replace RANLIB and be more verbose, bug #792252
		-e "/ranlib/ {h;s/ranlib/echo &/;G;s:ranlib:$(tc-getRANLIB):g}"
	)
	sed -i "${sed_args[@]}" Makefile || die
}

src_configure() {
	echo "${EPREFIX}/var/qmail" > conf-qmail || die
	echo "/var/qmail/bin" > conf-bin || die
	echo "/usr/$(get_libdir)/mailfront" > conf-modules || die
	echo "/usr/include" > conf-include || die
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${CFLAGS} -fPIC -shared ${LDFLAGS}" > conf-ccso || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
}

src_install() {
	emake install install_prefix="${ED}"
	exeinto /var/qmail/supervise/qmail-smtpd
	newexe "${FILESDIR}"/run-smtpfront run.mailfront
	exeinto /var/qmail/supervise/qmail-pop3d
	newexe "${FILESDIR}"/run-pop3front run.mailfront

	dodoc ANNOUNCEMENT ChangeLog NEWS README TODO VERSION
	docinto html
	dodoc *.html
}

pkg_config() {
	cd "${EROOT}"/var/qmail/supervise/qmail-smtpd/ || die
	[[ -e run ]] && ( cp run run.qmail-smtpd.`date +%Y%m%d%H%M%S` || die )
	cp run.mailfront run || die

	cd "${EROOT}"/var/qmail/supervise/qmail-pop3d/ || die
	[[ -e run ]] && ( cp run run.qmail-pop3d.`date +%Y%m%d%H%M%S` || die )
	cp run.mailfront run || die
}

pkg_postinst() {
	elog "Run"
	elog "emerge --config '=${CATEGORY}/${PF}'"
	elog "to update your run files (backups are created) in"
	elog "		/var/qmail/supervise/qmail-pop3d and"
	elog "		/var/qmail/supervise/qmail-smtpd"
}
