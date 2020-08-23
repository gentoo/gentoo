# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Leverage the OpenPGP web of trust for OpenSSH and Web authentication"
HOMEPAGE="http://web.monkeysphere.info/"

LICENSE="GPL-3"
SLOT="0/0"
IUSE=""
SRC_URI="
	mirror://debian/pool/monkeysphere/m/monkeysphere/monkeysphere_${PV}.orig.tar.gz
	http://archive.monkeysphere.info/debian/pool/monkeysphere/m/monkeysphere/monkeysphere_${PV}.orig.tar.gz"
KEYWORDS="~amd64 ~arm ~x86"

DOCS=( README Changelog )

## Tests fail upstream for SSH connection. Issue has been reported.
RESTRICT="test"

DEPEND="acct-group/monkeysphere
	acct-user/monkeysphere
	>=app-crypt/gnupg-2.1.17:0=
	net-misc/socat:0=
	dev-perl/Crypt-OpenSSL-RSA:0=
	dev-perl/Digest-SHA1:0=
	app-misc/lockfile-progs:0="

RDEPEND="${DEPEND}
	net-misc/openssh"

PATCHES=( "${FILESDIR}"/${PN}-0.44-install-uncompressed-man-pages.patch )

src_prepare() {
	default

	sed -i \
		-e "s#share/doc/monkeysphere#share/doc/${PF}#" \
		Makefile \
		|| die
}

pkg_postinst() {
	monkeysphere-authentication setup
}
