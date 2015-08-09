# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# Normally you need only one version of this.
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads,sqlite?,ssl?"

inherit eutils distutils-r1

DESCRIPTION="Powerful IMAP/Maildir synchronization and reader support"
HOMEPAGE="http://offlineimap.org"
SRC_URI="https://github.com/OfflineIMAP/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc ssl sqlite"

DEPEND="doc? ( app-text/asciidoc )"

src_prepare() {
	distutils-r1_src_prepare
	# see http://pogma.com/2009/09/09/snow-leopard-and-offlineimap/ and bug 284925
	epatch "${FILESDIR}"/"${PN}-6.5.3.1"-darwin10.patch
}

src_compile() {
	distutils-r1_src_compile
	use doc && emake -C docs man
}

src_install() {
	distutils-r1_src_install
	dodoc offlineimap.conf offlineimap.conf.minimal
	use doc && doman docs/{offlineimap.1,offlineimapui.7}
}

pkg_postinst() {
	echo
	elog "You will need to configure offlineimap by creating ~/.offlineimaprc"
	elog "Sample configurations are in /usr/share/doc/${PF}/"
	elog ""
	elog "If you connect via ssl/tls and don't use CA cert checking, it will"
	elog "display the server's cert fingerprint and require you to add it to the"
	elog "configuration file to be sure it connects to the same server every"
	elog "time. This serves to help fixing CVE-2010-4532 (offlineimap doesn't"
	elog "check SSL server certificate) in cases where you have no CA cert."
	echo

	if use sqlite ; then
		elog "The sqlite USE flag only enables a dependency on sqlite. To use"
		elog "the sqlite backend you need to enable it in your .offlineimaprc"
	fi
}
