# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

PYTHON_DEPEND="2:2.5"
PYTHON_USE_WITH="threads"

# Maintainer note:
#  keep this package at 4.4.0.
#    5.x - requires wxpython-2.6 which we don't carry
#    6.x - binary-only non-free crap
# Fedora has also frozen bittorrent at 4.4.0 and is a good source of patches
# http://pkgs.fedoraproject.org/gitweb/?p=bittorrent.git

inherit distutils eutils fdo-mime python

MY_P="${P/bittorrent/BitTorrent}"

DESCRIPTION="Tool for distributing files via a distributed network of nodes"
HOMEPAGE="http://www.bittorrent.com/"
SRC_URI="http://www.bittorrent.com/dl/${MY_P}.tar.gz"

LICENSE="BitTorrent"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="aqua gtk"

RDEPEND=">=dev-python/pycrypto-2.0
	gtk? (	>=x11-libs/gtk+-2.6:2
			>=dev-python/pygtk-2.6:2 )"
DEPEND="${RDEPEND}"
#	dev-python/dnspython"

S=${WORKDIR}/${MY_P}

DOCS="README.txt TRACKERLESS.txt"
PYTHON_MODNAME="BitTorrent khashmir"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	distutils_src_prepare

	epatch "${FILESDIR}"/${P}-no-version-check.patch
	epatch "${FILESDIR}"/${P}-pkidir.patch
	epatch "${FILESDIR}"/${P}-fastresume.patch
	epatch "${FILESDIR}"/${P}-pygtk-thread-warnings.patch
	epatch "${FILESDIR}"/${P}-python26-syntax.patch
	epatch "${FILESDIR}"/${P}-bencode-float.patch
	epatch "${FILESDIR}"/${P}-keyerror.patch
	epatch "${FILESDIR}"/${P}-hashlib.patch

	# fix doc path #109743
	sed -i -e "/dp.*appdir/ s:appdir:'${PF}':" BitTorrent/platform.py
}

src_install() {
	distutils_src_install

	if use gtk; then
		doicon images/bittorrent.ico
		domenu "${FILESDIR}"/${PN}.desktop
	elif use !aqua; then
		rm -f "${ED}"usr/bin/{bit,make}torrent
	fi

	insinto /etc/pki/bittorrent/
	doins public.key

	newinitd "${FILESDIR}"/bittorrent-tracker.initd bittorrent-tracker
	newconfd "${FILESDIR}"/bittorrent-tracker.confd bittorrent-tracker
}

pkg_postinst() {
	distutils_pkg_postinst
	use gtk && fdo-mime_desktop_database_update
}

pkg_postrm() {
	distutils_pkg_postrm
	use gtk && fdo-mime_desktop_database_update
}
