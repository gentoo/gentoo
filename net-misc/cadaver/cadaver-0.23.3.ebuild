# Copyright 2003-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="Command-line WebDAV client"
HOMEPAGE="http://webdav.org/cadaver/"
SRC_URI="http://webdav.org/cadaver/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 ~sparc x86"
IUSE="nls"

RDEPEND=">=net-libs/neon-0.27.0"
DEPEND="${RDEPEND}
	sys-devel/gettext"

DOCS=(BUGS ChangeLog FAQ NEWS README THANKS TODO)

src_prepare() {
	eapply "${FILESDIR}/${PN}-0.23.2-disable-nls.patch"
	eapply_user

	rm -r lib/{expat,intl,neon} || die "rm failed"
	sed \
		-e "/NE_REQUIRE_VERSIONS/s:29:& 30:" \
		-e "/AM_GNU_GETTEXT/s:no-libtool:external:" \
		-e "/AC_CONFIG_FILES/s: lib/neon/Makefile lib/intl/Makefile::" \
		-i configure.ac || die "sed configure.ac failed"
	sed -e "s:^\(SUBDIRS.*=\).*:\1:" -i Makefile.in || die "sed Makefile.in failed"
	cp "${EPREFIX}/usr/share/gettext/po/Makefile.in.in" po || die "cp failed"

	AT_M4DIR="m4 m4/neon" eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		--with-libs=/usr
}
