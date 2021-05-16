# Copyright 2003-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="Command-line WebDAV client"
HOMEPAGE="http://webdav.org/cadaver/ https://github.com/notroj/cadaver"
SRC_URI="http://webdav.org/cadaver/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 ~sparc x86"
IUSE="nls"

BDEPEND="sys-devel/gettext"
DEPEND=">=net-libs/neon-0.27.0"
RDEPEND="${DEPEND}"

DOCS=(BUGS ChangeLog FAQ NEWS README THANKS TODO)

src_prepare() {
	eapply "${FILESDIR}/${PN}-0.23.2-disable-nls.patch"
	eapply_user

	rm -r lib/{expat,intl,neon} || die "rm failed"
	sed \
		-e "/NE_REQUIRE_VERSIONS/s:29:& 30 31:" \
		-e "/AM_GNU_GETTEXT/s:no-libtool:external:" \
		-e "/AC_CONFIG_FILES/s: lib/neon/Makefile lib/intl/Makefile::" \
		-i configure.ac || die "sed configure.ac failed"
	sed -e "s:^\(SUBDIRS.*=\).*:\1:" -i Makefile.in || die "sed Makefile.in failed"
	cp "${BROOT}/usr/share/gettext/po/Makefile.in.in" po || die "cp failed"

	config_rpath_update .
	AT_M4DIR="m4 m4/neon" eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls)
}
