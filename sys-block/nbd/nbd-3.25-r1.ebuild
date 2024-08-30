# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Userland client/server for kernel network block device"
HOMEPAGE="https://nbd.sourceforge.io/"

if [[ ${PV} == 9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/NetworkBlockDevice/nbd.git"
else
	SRC_URI="https://github.com/NetworkBlockDevice/nbd/releases/download/${P}/${P}.tar.xz"
	SRC_URI+=" https://downloads.sourceforge.net/nbd/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug gnutls netlink zlib"

RDEPEND="
	>=dev-libs/glib-2.32.0
	gnutls? ( >=net-libs/gnutls-2.12.0 )
	netlink? ( >=dev-libs/libnl-3.1 )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-3.25-fix-build-on-musl-gcc14.patch"
)

if [[ ${PV} == 9999 ]] ; then
	BDEPEND+="
		app-text/docbook-sgml-dtd:4.5
		app-text/docbook-sgml-utils
		dev-build/autoconf-archive
	"
fi

src_prepare() {
	default

	if [[ ${PV} == 9999 ]] ; then
		emake -C man -f mans.mk \
			nbd-server.1.sh.in \
			nbd-server.5.sh.in \
			nbd-client.8.sh.in \
			nbd-trdump.1.sh.in \
			nbd-trplay.1.sh.in \
			nbdtab.5.sh.in

		emake -C systemd -f Makefile.am nbd@.service.sh.in

		eautoreconf
	fi
}

src_configure() {
	# Needs Bison
	unset YACC

	local myeconfargs=(
		--enable-lfs
		# https://github.com/NetworkBlockDevice/nbd/issues/149
		--disable-gznbd
		$(use_enable !debug syslog)
		$(use_enable debug)
		$(use_with gnutls)
		$(use_with netlink libnl)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	systemd_dounit systemd/nbd@.service
}
