# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit readme.gentoo-r1

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A high performance inline data deduplicating filesystem"
HOMEPAGE="https://sourceforge.net/projects/lessfs/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${MY_P}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="berkdb crypt debug filelog memtrace lzo snappy"

RDEPEND="
	berkdb? ( sys-libs/db:* )
	crypt? ( dev-libs/openssl:0= )
	lzo? ( dev-libs/lzo )
	snappy? ( app-arch/snappy )
	>=dev-db/tokyocabinet-1.4.42
	app-crypt/mhash
	>=sys-fs/fuse-2.8.0:0=
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

DOC_CONTENTS="Default configuration file: /etc/${PN}.cfg.
	If your host is a client consult the following configuration
	file: /usr/share/doc/${PF}/${PN}.cfg-slave.*"

PATCHES=(
	# From PLD-Linux, bug #674422
	"${FILESDIR}/${P}-openssl11.patch"
)

src_configure() {
	econf \
		$(use_enable debug) $(use_enable debug lckdebug) \
		$(use_enable filelog) $(use_with crypt crypto) \
		$(use_with lzo) $(use_enable memtrace) \
		$(use_with berkdb berkeleydb) \
		$(use_with snappy)
}

src_install () {
	default
	insinto /etc
	newins examples/lessfs.cfg-master ${PN}.cfg
	dodoc examples/lessfs.* etc/lessfs.*
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
