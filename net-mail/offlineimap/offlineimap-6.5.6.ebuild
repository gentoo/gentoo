# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# Normally you need only one version of this.
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads,sqlite?,ssl?"

inherit eutils distutils-r1

DESCRIPTION="Powerful IMAP/Maildir synchronization and reader support"
HOMEPAGE="https://www.offlineimap.org/"
SRC_URI="https://github.com/OfflineIMAP/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc ssl sqlite"

RDEPEND=""
DEPEND="doc? ( dev-python/docutils )"
S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}/"
}

src_prepare() {
	distutils-r1_src_prepare
	# see http://pogma.com/2009/09/09/snow-leopard-and-offlineimap/ and bug 284925
	epatch "${FILESDIR}"/"${PN}-6.5.3.1"-darwin10.patch
}

src_compile() {
	distutils-r1_src_compile
	if use doc ; then
		cd docs
		rst2man.py MANUAL.rst offlineimap.1 || die "building manpage failed"
	fi
}

src_install() {
	distutils-r1_src_install
	dodoc offlineimap.conf offlineimap.conf.minimal
	if use doc ; then
		cd docs
		doman offlineimap.1
	fi
}

pkg_preinst() {
	if has_version "<${CATEGORY}/${PN}-6.4" ; then
		elog "If you upgraded from 6.3.* then you may need to update your config:"
		elog ""
		elog "If you use nametrans= settings on a remote repository, you will have"
		elog "to add a \"reverse\" nametrans setting to the local repository, so that"
		elog "it knows which folders it should (not) create on the remote side."
		elog ""
	fi
}

pkg_postinst() {
	elog ""
	elog "You will need to configure offlineimap by creating ~/.offlineimaprc"
	elog "Sample configurations are in /usr/share/doc/${PF}/"
	elog ""
	elog "If you connect via ssl/tls and don't use CA cert checking, it will"
	elog "display the server's cert fingerprint and require you to add it to the"
	elog "configuration file to be sure it connects to the same server every"
	elog "time. This serves to help fixing CVE-2010-4532 (offlineimap doesn't"
	elog "check SSL server certificate) in cases where you have no CA cert."
	elog ""

	if use sqlite ; then
		elog "The sqlite USE flag only enables a dependency on sqlite. To use"
		elog "the sqlite backend you need to enable it in your .offlineimaprc"
	fi
}
