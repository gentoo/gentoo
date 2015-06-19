# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/htpdate/htpdate-1.0.5.ebuild,v 1.2 2013/08/12 07:50:18 pinkbyte Exp $

EAPI=5

inherit readme.gentoo toolchain-funcs unpacker

DESCRIPTION="Synchronize local workstation with time offered by remote webservers"
HOMEPAGE="http://www.vervest.org/fiki/bin/view/HTP/DownloadC"
SRC_URI="http://www.vervest.org/htp/archive/c/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-linux ~x86-linux"

DEPEND=""
RDEPEND=""

DOC_CONTENTS="If you would like to run htpdate as a daemon, set
appropriate http servers in /etc/conf.d/htpdate!"

src_unpack() {
	default

	cd "${S}" || die "change directory to ${S} failed"
	unpacker htpdate.8.gz
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
