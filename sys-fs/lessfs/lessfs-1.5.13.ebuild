# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/lessfs/lessfs-1.5.13.ebuild,v 1.3 2013/03/03 23:08:19 hwoarang Exp $

EAPI="5"
inherit readme.gentoo

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="A high performance inline data deduplicating filesystem"
HOMEPAGE="http://www.lessfs.com"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${MY_P}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="berkdb crypt debug filelog memtrace lzo"

DEPEND="berkdb? ( sys-libs/db )
		>=dev-db/tokyocabinet-1.4.42
		app-crypt/mhash
		>=sys-fs/fuse-2.8.0
		crypt? ( dev-libs/openssl )
		lzo? ( dev-libs/lzo )"

RDEPEND=""

S="${WORKDIR}/${MY_P}"

DOC_CONTENTS="Default configuration file: /etc/${PN}.cfg.
	If your host is a client consult the following configuration
	file: /usr/share/doc/${PF}/${PN}.cfg-slave.*"

src_configure() {
	econf \
		$(use_enable debug) $(use_enable debug lckdebug) \
		$(use_enable filelog) $(use_with crypt crypto) \
		$(use_with lzo) $(use_enable memtrace) \
		$(use_with berkdb berkeleydb)
}

src_install () {
	emake DESTDIR="${D}" install
	dodoc ChangeLog FAQ README.*
	insinto /etc
	newins examples/lessfs.cfg-master ${PN}.cfg
	dodoc examples/lessfs.* etc/lessfs.*
	readme.gentoo_create_doc
}
