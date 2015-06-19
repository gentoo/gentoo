# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/cvsweb/cvsweb-1.112.ebuild,v 1.1 2010/03/05 18:11:28 ulm Exp $

DESCRIPTION="WWW interface to a CVS tree"
HOMEPAGE="http://www.freebsd.org/projects/cvsweb.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 sparc ~ppc"
IUSE=""

RDEPEND=">=dev-lang/perl-5
	>=dev-vcs/rcs-5.7"

S="${WORKDIR}/cvsweb"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
	local x
	for x in cvsweb.cgi cvsweb.conf
	do
		cp ${x} ${x}.orig
		sed -e "s:/usr/local/web/apache/conf/:/etc/apache/conf/:g" ${x}.orig > ${x}
	done
}

src_install() {
	insinto /etc/apache/conf
	doins cvsweb.conf
	insinto /home/httpd/cgi-bin
	insopts -m755
	doins cvsweb.cgi
	dodoc README TODO
}
