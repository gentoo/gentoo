# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils user

DESCRIPTION="Leverage the OpenPGP web of trust for OpenSSH and Web authentication"
HOMEPAGE="http://web.monkeysphere.info/"

LICENSE="GPL-3"
SLOT="0/0"
IUSE=""
SRC_URI="mirror://debian/pool/monkeysphere/m/monkeysphere/monkeysphere_${PV}.orig.tar.gz http://archive.monkeysphere.info/debian/pool/monkeysphere/m/monkeysphere/monkeysphere_${PV}.orig.tar.gz"
KEYWORDS="~amd64 ~arm ~x86"

DOCS=( README Changelog )

# Tests fail upstream for SSH connection. Issue has been reported.
RESTRICT="test"

DEPEND="app-crypt/gnupg:0=
	net-misc/socat:0=
	dev-perl/Crypt-OpenSSL-RSA:0=
	dev-perl/Digest-SHA1:0=
	app-misc/lockfile-progs:0="

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
	       "${FILESDIR}/${P}_hd_od.patch"

	sed -i "s#share/doc/monkeysphere#share/doc/${PF}#" Makefile || die
}

src_install()
{
	default
	dodir /var/lib/monkeysphere
}

pkg_postinst()
{
	monkeysphere-authentication setup || die
}
