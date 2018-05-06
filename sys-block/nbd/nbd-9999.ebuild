# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Userland client/server for kernel network block device"
HOMEPAGE="http://nbd.sourceforge.net/"
if [[ "${PV}" = 9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/NetworkBlockDevice/nbd.git"
else
	SRC_URI="mirror://sourceforge/nbd/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi
LICENSE="GPL-2"
SLOT="0"
IUSE="debug gnutls netlink zlib"

# gnutls is an automagic dep.
RDEPEND="
	>=dev-libs/glib-2.26.0
	gnutls? ( >=net-libs/gnutls-2.12.0 )
	netlink? ( >=dev-libs/libnl-3.1 )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

if [[ "${PV}" = 9999 ]] ; then
	DEPEND+="
		app-text/docbook-sgml-dtd:4.5
		app-text/docbook-sgml-utils
	"
fi

PATCHES=(
	"${FILESDIR}/${PN}-3.17-automagic.patch"
)

src_prepare() {
	default
	if [[ "${PV}" = 9999 ]] ; then
		emake -C man -f Makefile.am \
			nbd-server.1.sh.in \
			nbd-server.5.sh.in \
			nbd-client.8.sh.in \
			nbd-trdump.1.sh.in \
			nbdtab.5.sh.in
		emake -C systemd -f Makefile.am nbd@.service.sh.in
		eautoreconf
	fi
}

src_configure() {
	local myeconfargs=(
		--enable-lfs
		$(use_enable !debug syslog)
		$(use_enable debug)
		$(use_enable zlib gznbd)
		$(use_with gnutls)
		$(use_with netlink libnl)
	)
	econf "${myeconfargs[@]}"
}
