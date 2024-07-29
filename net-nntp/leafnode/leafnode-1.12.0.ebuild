# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A USENET software package designed for small sites"
HOMEPAGE="http://leafnode.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND=">=dev-libs/libpcre2-10"
RDEPEND="${DEPEND}
	virtual/inetd"
DOCS=( CREDITS ChangeLog FAQ.txt FAQ.pdf INSTALL NEWS UNINSTALL-daemontools README README-MAINTAINER README-FQDN )

src_configure() {
	econf \
		--sysconfdir=/etc/leafnode \
		--localstatedir=/var \
		--with-spooldir=/var/spool/news \
		--with-ipv6
}

src_install() {
	default

	keepdir \
		/var/lib/news \
		/var/spool/news/{failed.postings,interesting.groups,leaf.node,out.going,temp.files} \
		/var/spool/news/message.id/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}

	fowners -R news:news /var/{lib,spool}/news

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/leafnode.xinetd leafnode-nntp

	exeinto /etc/cron.hourly
	newexe "${FILESDIR}"/fetchnews.cron fetchnews
	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/texpire.cron texpire

	dodoc FAQ.html FAQ.xml README-FQDN.html
}
