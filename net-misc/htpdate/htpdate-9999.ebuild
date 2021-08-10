# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic readme.gentoo-r1 toolchain-funcs

DESCRIPTION="Synchronize local workstation with time offered by remote webservers"
HOMEPAGE="https://github.com/angeloc/htpdate"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/angeloc/htpdate.git"
else
	SRC_URI="https://github.com/angeloc/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~s390 ~x86 ~amd64-linux ~x86-linux"
fi
IUSE="+ssl"
LICENSE="GPL-2"
SLOT="0"

DEPEND="ssl? ( dev-libs/openssl:0= )"
RDEPEND="${DEPEND}"
BDEPEND="ssl? ( virtual/pkgconfig )"

DOC_CONTENTS="If you would like to run htpdate as a daemon, set
appropriate http servers in /etc/conf.d/htpdate!"

PATCHES=( "${FILESDIR}/${PN}-1.2.6-ldlibs.patch" )

src_prepare() {
	default

	# Use more standard adjtimex() to fix uClibc builds.
	sed -i 's:ntp_adjtime:adjtimex:g' htpdate.[8c] || die
	# Don't compress man pages by default
	sed '/gzip/d' -i Makefile || die
}

src_compile() {
	if use ssl ; then
		append-cflags -DENABLE_HTTPS
		export PKG_CONFIG="$(tc-getPKG_CONFIG)"
	fi

	emake CFLAGS="-Wall ${CFLAGS}" CC="$(tc-getCC)" \
		$(usex ssl 'ENABLE_HTTPS=1' '')
}

src_install() {
	emake DESTDIR="${D}" bindir='$(prefix)/sbin' install
	dodoc README.md Changelog

	newconfd "${FILESDIR}"/htpdate.conf htpdate
	newinitd "${FILESDIR}"/htpdate.init-r1 htpdate

	readme.gentoo_create_doc
}
