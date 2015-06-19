# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/daemonize/daemonize-1.6.ebuild,v 1.4 2014/01/16 17:32:56 jer Exp $

EAPI=2

DESCRIPTION="Runs a command as a Unix daemon"
HOMEPAGE="http://bmc.github.com/daemonize/"
SRC_URI="http://github.com/bmc/${PN}/tarball/release-${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_unpack() {
	unpack ${A}
	# Workaround commit suffix from github.
	mv "${WORKDIR}"/bmc-${PN}-* "${S}" || die
}

src_prepare() {
	sed -i \
		-e 's:\($(CC)\) $(CFLAGS) \(.*\.o\):\1 $(LDFLAGS) \2:' \
		Makefile.in || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README.md CHANGELOG || die
}
