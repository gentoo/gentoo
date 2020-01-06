# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Runs a command as a Unix daemon"
HOMEPAGE="https://bmc.github.com/daemonize/"
SRC_URI="https://github.com/bmc/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DOCS=( CHANGELOG.md README.md )

S="${WORKDIR}/${PN}-release-${PV}"

src_prepare() {
	default
	sed -i \
		-e 's:\($(CC)\) $(CFLAGS) \(.*\.o\):\1 $(LDFLAGS) \2:' \
		Makefile.in || die
}
