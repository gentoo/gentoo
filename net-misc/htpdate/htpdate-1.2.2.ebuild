# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 toolchain-funcs

DESCRIPTION="Synchronize local workstation with time offered by remote webservers"
HOMEPAGE="http://www.vervest.org/htp/"
SRC_URI="http://www.vervest.org/htp/archive/c/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ~ppc64 s390 x86 ~amd64-linux ~x86-linux"

DEPEND=""
RDEPEND=""

DOC_CONTENTS="If you would like to run htpdate as a daemon, set
appropriate http servers in /etc/conf.d/htpdate!"

src_prepare() {
	default

	# Use more standard adjtimex() to fix uClibc builds.
	sed -i 's:ntp_adjtime:adjtimex:g' htpdate.[8c] || die
}

src_compile() {
	emake CFLAGS="-Wall ${CFLAGS} ${LDFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	dosbin htpdate
	doman htpdate.8
	dodoc README Changelog

	newconfd "${FILESDIR}"/htpdate.conf htpdate
	newinitd "${FILESDIR}"/htpdate.init-r1 htpdate

	readme.gentoo_create_doc
}
