# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/syrep/syrep-0.9.ebuild,v 1.3 2010/07/14 11:37:11 ssuominen Exp $

EAPI=2
inherit autotools

DESCRIPTION="A generic file repository synchronization tool"
HOMEPAGE="http://0pointer.de/lennart/projects/syrep/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="sys-libs/zlib
	>=sys-libs/db-4.3
	doc? ( www-client/lynx )"

src_prepare() {
	sed -i \
		-e "s/#if (DB_VERSION_MAJOR != 4).*/#if (DB_VERSION_MAJOR < 4)/" \
		configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable doc lynx) \
		--disable-xmltoman \
		--disable-subversion \
		--disable-gengetopt
}

src_install() {
	emake DESTDIR="${D}" install || die
	cd doc
	dodoc README *.txt
	use doc && dohtml *.html *.css
}
