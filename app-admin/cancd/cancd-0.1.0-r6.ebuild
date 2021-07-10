# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="CA NetConsole Daemon receives output from the Linux netconsole driver"
HOMEPAGE="http://oss.oracle.com/projects/cancd/"
SRC_URI="http://oss.oracle.com/projects/cancd/dist/files/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/${P}-build-r1.patch"
	"${FILESDIR}/${P}-c-cleanup.patch"
)

RDEPEND="
	acct-group/cancd
	acct-user/cancd
"

src_prepare() {
	default

	# slight makefile cleanup
	sed \
		-e '/^CFLAGS/s,-g,,' \
		-e '/^CFLAGS/s,-O2,-Wall -W -Wextra -Wundef -Wendif-labels -Wshadow -Wpointer-arith -Wbad-function-cast -Wcast-qual -Wcast-align -Wwrite-strings -Wconversion -Wsign-compare -Waggregate-return -Wstrict-prototypes -Wredundant-decls -Wunreachable-code -Wlong-long,' \
		-e '/rm cancd cancd.o/s,rm,rm -f,' \
		-i Makefile || die
}

src_install() {
	dosbin cancd

	newinitd "${FILESDIR}"/cancd-init.d-r1 cancd
	newconfd "${FILESDIR}"/cancd-conf.d-r1 cancd
	newinitd "${FILESDIR}"/netconsole-init.d netconsole
	newconfd "${FILESDIR}"/netconsole-conf.d netconsole
}
