# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Tools to extract and convert images in icon and cursor files (.ico, .cur)"
HOMEPAGE="http://www.nongnu.org/icoutils/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="nls"

BDEPEND="
	nls? ( sys-devel/gettext )
"
RDEPEND="
	>=dev-lang/perl-5.6
	>=dev-perl/libwww-perl-5.64
	media-libs/libpng:0
	sys-libs/zlib
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

PATCHES=( "${FILESDIR}"/${PN}-0.29.1-{locale,gettext}.patch )

src_prepare() {
	default
	rm m4/po.m4* || die
	cp /usr/share/aclocal/po.m4 m4/ || die
	AT_M4DIR=m4 eautoreconf
}

src_configure() {
	use !elibc_glibc && use !elibc_musl && use nls && append-libs -lintl
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" mkinstalldirs="mkdir -p" install
	einstalldocs
}
