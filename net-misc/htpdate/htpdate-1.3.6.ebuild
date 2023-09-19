# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1 toolchain-funcs

DESCRIPTION="Synchronize local workstation with time offered by remote webservers"
HOMEPAGE="https://www.vervest.org/htp/"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/twekkel/htpdate"
else
	SRC_URI="https://github.com/twekkel/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ~ppc64 ~s390 x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+ssl"

DEPEND="ssl? ( dev-libs/openssl:= )"
RDEPEND="${DEPEND}"

# Test suite tries to connect to the Internet
RESTRICT="test"

DOC_CONTENTS="If you would like to run htpdate as a daemon, set
appropriate http servers in /etc/conf.d/htpdate!"

src_prepare() {
	default

	# Use more standard adjtimex() to fix uClibc builds.
	sed -i 's:ntp_adjtime:adjtimex:g' htpdate.[8c] || die
	# Don't compress man pages by default
	sed '/gzip/d' -i Makefile || die
}

src_compile() {
	emake \
		CFLAGS="-Wall ${CFLAGS} ${CPPFLAGS} ${LDFLAGS}" \
		CC="$(tc-getCC)" \
		$(usev ssl 'https')
}

src_install() {
	emake DESTDIR="${D}" STRIP="/bin/true" bindir='$(prefix)/sbin' install
	dodoc README.md Changelog

	newconfd "${FILESDIR}"/htpdate.conf htpdate
	newinitd "${FILESDIR}"/htpdate.init-r1 htpdate

	readme.gentoo_create_doc
}
