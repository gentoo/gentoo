# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd

DESCRIPTION="System uptime record daemon that keeps track of your highest uptimes"
HOMEPAGE="https://github.com/rpodgorny/uptimed/"
SRC_URI="https://github.com/rpodgorny/uptimed/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	acct-group/uptimed
	acct-user/uptimed
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	local DOCS=( ChangeLog README.md TODO AUTHORS CREDITS INSTALL.cgi sample-cgi/* )
	default
	find "${ED}" -type f -name '*.la' -delete || die

	local spooldir="/var/spool/${PN}"
	keepdir ${spooldir}
	fowners uptimed:uptimed ${spooldir}

	newinitd "${FILESDIR}"/${PN}.init-r1 uptimed
	systemd_dounit "${FILESDIR}/${PN}.service"
}

pkg_postinst() {
	local spooldir="/var/spool/${PN}"
	if [[ -d "${spooldir}" ]] ; then
		einfo "Fixing permissions in ${spooldir}"
		find ${spooldir} -type f -links 1 \
			\( -name records -o -name records.old \) \
			| xargs --no-run-if-empty chown uptimed:uptimed || die
	fi
	echo
	elog "Start uptimed with '/etc/init.d/uptimed start' (for openRC)"
	elog "or systemctl start uptimed (for systemd)"
	elog "To view your uptime records, use the command 'uprecords'."
	echo
}
