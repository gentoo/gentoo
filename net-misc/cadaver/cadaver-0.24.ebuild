# Copyright 2003-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Command-line WebDAV client"
HOMEPAGE="https://notroj.github.io/cadaver/ https://github.com/notroj/cadaver"
SRC_URI="https://notroj.github.io/cadaver/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 ~sparc x86"
IUSE="nls"

BDEPEND="sys-devel/gettext"
DEPEND=">=net-libs/neon-0.27.0:="
RDEPEND="${DEPEND}"

DOCS=( BUGS ChangeLog FAQ NEWS README.md THANKS TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-0.23.2-disable-nls.patch
	"${FILESDIR}"/${PN}-0.24-neon-0.33.patch
	"${FILESDIR}"/${PN}-0.24-autoconf-2.72.patch
	"${FILESDIR}"/${PN}-0.24-link-cflags.patch
)

src_prepare() {
	default

	rm -r lib/expat || die "rm failed"
	sed \
		-e "/AC_CONFIG_FILES/s: neon/src/Makefile::" \
		-i configure.ac || die "sed configure.ac failed"
	sed -e "s:^\(SUBDIRS.*=\).*:\1:" -i Makefile.in || die "sed Makefile.in failed"
	cp "${BROOT}"/usr/share/gettext/po/Makefile.in.in po || die "cp failed"

	config_rpath_update .
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls)
}
