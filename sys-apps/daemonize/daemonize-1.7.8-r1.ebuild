# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Runs a command as a Unix daemon"
HOMEPAGE="https://software.clapper.org/daemonize/"
SRC_URI="https://github.com/bmc/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-release-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( {CHANGELOG,README}.md )

src_prepare() {
	default
	sed -i \
		-e 's:\($(CC)\) $(CFLAGS) \(.*\.o\):\1 $(LDFLAGS) \2:' \
		Makefile.in || die
}
