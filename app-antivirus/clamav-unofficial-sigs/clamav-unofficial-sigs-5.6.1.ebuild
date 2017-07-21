# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Download and install third-party clamav signatures"
HOMEPAGE="https://github.com/extremeshok/${PN}"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# We need its user/group.
DEPEND="app-antivirus/clamav"

# The script relies on either net-misc/socat, or Perl's
# IO::Socket::UNIX. We already depend on Perl, and Gentoo's Perl ships
# with IO::Socket::UNIX, so we can leave out net-misc/socat here.
RDEPEND="${DEPEND}
	app-crypt/gnupg
	dev-lang/perl
	net-dns/bind-tools
	|| ( net-misc/wget net-misc/curl )"

src_install() {
	dosbin "${PN}.sh"

	# The script's working directory (set in the conf file). By default,
	# it runs as clamav/clamav.
	diropts -m 0755 -o clamav -g clamav
	dodir "/var/lib/${PN}"

	insinto /etc/logrotate.d
	doins "${FILESDIR}/${PN}.logrotate"

	insinto "/etc/${PN}"
	doins config/{master,user}.conf
	newins config/os.gentoo.conf os.conf

	doman "${FILESDIR}/${PN}.8"
	dodoc README.md
}

pkg_postinst() {
	elog ''
	elog "You will need to select databases in /etc/${PN}/master.conf."
	elog "For details, please see the ${PN}(8) manual page."
	elog ''
	elog 'An up-to-date description of the available Sanesecurity'
	elog 'databases is available at,'
	elog ''
	elog '  http://sanesecurity.com/usage/signatures/'
	elog ''
	ewarn 'The configuration file has moved in the 5.x version!'
	ewarn "You should migrate your config from /etc/${PN}.conf to"
	ewarn "/etc/${PN}/master.conf"
	ewarn ''
}
