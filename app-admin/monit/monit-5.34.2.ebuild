# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 pam systemd

DESCRIPTION="Monitoring and managing daemons or similar programs running on a Unix system"
HOMEPAGE="http://mmonit.com/monit/"
SRC_URI="http://mmonit.com/monit/dist/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux"
IUSE="pam ssl"

RDEPEND="sys-libs/zlib:=
	virtual/libcrypt:=
	pam? ( sys-libs/pam )
	ssl? ( dev-libs/openssl:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
"

src_prepare() {
	default
	sed -i -e '/^INSTALL_PROG/s/-s//' Makefile.in || die
}

src_configure() {
	local myeconfargs=(
		$(use_with pam)
		$(use_with ssl)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/monit.logrotate monit

	insinto /etc; insopts -m600; doins monitrc
	newinitd "${FILESDIR}"/monit.initd-5.0-r1 monit
	systemd_dounit system/startup/${PN}.service

	use pam && newpamd "${FILESDIR}"/${PN}.pamd ${PN}

	dobashcomp system/bash/monit
}

pkg_postinst() {
	elog "Sample configurations are available at:"
	elog "http://mmonit.com/monit/documentation/"
}
