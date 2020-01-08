# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

DESCRIPTION="Download and install third-party clamav signatures"
HOMEPAGE="https://github.com/extremeshok/${PN}"
SRC_URI="https://github.com/extremeshok/clamav-unofficial-sigs/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

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
	# it runs as clamav/clamav. We set the owner/group later, in
	# pkg_preinst, after the user/group is sure to exist (because we
	# create them otherwise).
	keepdir "/var/lib/${PN}"

	insinto /etc/logrotate.d
	doins "${FILESDIR}/${PN}.logrotate"

	insinto "/etc/${PN}"
	doins config/{master,user}.conf
	newins config/os.gentoo.conf os.conf

	doman "${FILESDIR}/${PN}.8"
	dodoc README.md
}

pkg_preinst() {
	# Should agree with app-antivirus/clamav. We don't actually need
	# clamav to function, so it isn't one of our dependencies, and
	# that's why we might need to create its user ourselves.
	enewgroup clamav
	enewuser clamav -1 -1 /dev/null clamav
	fowners clamav:clamav "/var/lib/${PN}"
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
}
