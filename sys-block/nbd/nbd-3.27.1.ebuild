# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd

DESCRIPTION="Userland client/server for kernel network block device"
HOMEPAGE="https://nbd.sourceforge.io/"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/NetworkBlockDevice/nbd.git"
else
	# Use auto-generated tarballs for now as there's no dist tarball available
	# See https://github.com/NetworkBlockDevice/nbd/issues/198
	SRC_URI="https://github.com/NetworkBlockDevice/nbd/archive/refs/tags/${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ppc ppc64 ~sparc x86"
fi
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug gnutls"

RDEPEND="
	>=dev-libs/glib-2.32.0
	>=dev-libs/libnl-3.1
	gnutls? ( >=net-libs/gnutls-2.12.0 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-sgml-dtd:4.5
	app-text/docbook-sgml-utils
	dev-build/autoconf-archive
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

src_prepare() {
	default

	emake -C systemd -f Makefile.am nbd@.service.sh.in

	eautoreconf
}

src_configure() {
	# Needs Bison and flex
	unset YACC LEX

	local myeconfargs=(
		--enable-lfs
		--with-libnl
		$(use_enable !debug syslog)
		$(use_enable debug)
		$(use_with gnutls)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	systemd_dounit systemd/nbd@.service
}
