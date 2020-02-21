# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="Download and install third-party clamav signatures"
HOMEPAGE="https://github.com/extremeshok/clamav-unofficial-sigs"
SRC_URI="https://github.com/extremeshok/clamav-unofficial-sigs/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cron"

# Require acct-{user,group}/clamav at build time so that we can set
# the permissions on /var/lib/${PN} in src_install rather than in
# pkg_postinst; calling "chown" on the live filesystem scares me.
DEPEND="acct-group/clamav
	acct-user/clamav"

# The script relies on either net-misc/socat, or Perl's
# IO::Socket::UNIX. We already depend on Perl, and Gentoo's Perl ships
# with IO::Socket::UNIX, so we can leave out net-misc/socat here.
#
# Recent versions will crash if you don't have "clamscan" available,
# so we are forced to depend on app-antivirus/clamav finally.
RDEPEND="${DEPEND}
	app-antivirus/clamav
	app-crypt/gnupg
	dev-lang/perl
	net-dns/bind-tools
	|| ( net-misc/wget net-misc/curl )"

# This script is cccrrraaaaaaazzzzzzzzyyyyyy. It does a million
# insecure things. Let's not accidentally run it as root.
PATCHES=(
	"${FILESDIR}/${P}-disable-run-as-root.patch"
	"${FILESDIR}/${P}-fix-mbl-database-name.patch"
	"${FILESDIR}/${P}-fix-mbl-url.patch"
)

src_prepare() {
	default

	# https://github.com/extremeshok/clamav-unofficial-sigs/pull/301
	echo 'allow_upgrades="no"' >> config/os/os.gentoo.conf || die
	echo 'allow_update_checks="no"' >> config/os/os.gentoo.conf || die
}

src_install() {
	dobin "${PN}.sh"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"

	insinto "/etc/${PN}"
	doins config/{master,user}.conf
	newins config/os/os.gentoo.conf os.conf

	# To generate the man page, you have to first install the package,
	# and then issue some ridiculous command like
	#
	# $ sudo su -s /bin/sh \
	#           -c 'man_dir=/tmp clamav-unofficial-sigs.sh --install-man' \
	#           clamav
	#
	# That'll stick it in /tmp, which is unsafe-ish, but the example is
	# easily modified.
	newman "${FILESDIR}/${P}.man.8" "${PN}.8"
	dodoc README.md

	if use cron; then
		# Beware, this directory is not completely standard. However,
		# we need this to run as "clamav" with a non-default shell and
		# home directory (bug 694054), and this seems like the most
		# reliable way to accomplish that.
		insinto "/etc/cron.d"
		newins "${FILESDIR}/${PN}.crond" "${PN}"
	else
		dodoc "${FILESDIR}/${PN}.crond"
	fi

	# Install the systemd service and timer unconditionally, because
	# the timer is disabled by default (and won't annoy people until
	# after they've configured the script).
	systemd_dounit "${FILESDIR}/${PN}".{service,timer}

	# The script's working directory, as set in the configuration
	# file. By default, the script runs as clamav:clamav because
	# it needs write access to the clamav databases.
	diropts -o clamav -g clamav
	keepdir "/var/lib/${PN}"
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
