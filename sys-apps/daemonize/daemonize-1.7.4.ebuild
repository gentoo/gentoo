# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Runs a command as a Unix daemon"
HOMEPAGE="https://bmc.github.com/daemonize/"
SRC_URI="https://github.com/bmc/${PN}/tarball/release-${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DOCS=( README.md CHANGELOG.md )

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
