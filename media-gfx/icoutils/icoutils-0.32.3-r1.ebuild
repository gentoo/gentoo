# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Tools to extract and convert images in icon and cursor files (.ico, .cur)"
HOMEPAGE="https://www.nongnu.org/icoutils/"
SRC_URI="https://savannah.c3sl.ufpr.br/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86"
IUSE="nls"

BDEPEND="
	nls? ( sys-devel/gettext )
"
RDEPEND="
	>=dev-lang/perl-5.6
	>=dev-perl/libwww-perl-5.64
	media-libs/libpng:0
	virtual/zlib:=
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-0.29.1-{locale,gettext}.patch
	"${FILESDIR}"/${PN}-0.32.3-c23.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use !elibc_glibc && use !elibc_musl && use nls && append-libs -lintl
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" mkinstalldirs="mkdir -p" install
	einstalldocs
}
