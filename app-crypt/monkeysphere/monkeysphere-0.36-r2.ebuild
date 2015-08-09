# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils user

DESCRIPTION="Leverage the OpenPGP web of trust for OpenSSH and Web authentication"
HOMEPAGE="http://web.monkeysphere.info/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
SRC_URI="mirror://debian/pool/monkeysphere/m/monkeysphere/monkeysphere_${PV}.orig.tar.gz"
KEYWORDS="~amd64 ~arm ~x86"

DOCS=( README Changelog )

# Tests fail upstream for SSH connection. Issue has been reported.
RESTRICT="test"

DEPEND="app-crypt/gnupg
	net-misc/socat
	dev-perl/Crypt-OpenSSL-RSA
	dev-perl/Digest-SHA1
	app-misc/lockfile-progs"

RDEPEND="${DEPEND}"

pkg_setup()
{
	einfo "Creating named group and user"
	enewgroup monkeysphere
	enewuser monkeysphere -1 -1 /var/lib/monkeysphere monkeysphere
	# Using fperms and fowner in src_install leave unusable config with error
	# Authentication refused: bad ownership or modes for directory /var/lib/monkeysphere
	chown root:monkeysphere /var/lib/monkeysphere
	chmod 751 /var/lib/monkeysphere
}

src_prepare()
{
	epatch "${FILESDIR}/${P}_default_shell.patch"\
	       "${FILESDIR}/${P}_non_default_port.patch"\
	       "${FILESDIR}/${P}_userid_empty_line.patch"\
	       "${FILESDIR}/${P}_openpgp2ssh_sanity_check.patch"\
	       "${FILESDIR}/${P}_hd_od.patch"

	sed -i "s#share/doc/monkeysphere#share/doc/${PF}#" Makefile || die

	# Output format of gpg --check-sigs differ between 1.4 and 2.0 so test
	# needs to be updated if 2.0 is used
	if has_version '>=app-crypt/gnupg-2.0.0:0'; then
		epatch "${FILESDIR}/${P}_tests_gnupg2.patch"
	fi;
}

src_install()
{
	default
	dodir /var/lib/monkeysphere
}

pkg_postinst()
{
	#This function is idempotent, make sure it is run at least once.
	monkeysphere-authentication setup || die
}
