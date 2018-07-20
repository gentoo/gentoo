# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module

DESCRIPTION="Command-line static web gallery generator"
HOMEPAGE="http://home.gna.org/llgal"
SRC_URI="http://download.gna.org/llgal/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
# Package warrants IUSE doc and possibly examples
IUSE="exif"

RDEPEND="media-gfx/imagemagick
	 dev-perl/Image-Size
	 dev-perl/URI
	 dev-perl/Locale-gettext
	 exif? ( media-libs/exiftool )"

src_compile() {
	emake PREFIX=/usr SYSCONFDIR=/etc MANDIR=/usr/share/man PERL_INSTALLDIRS=vendor
	mv doc/llgalrc . || die
}

src_install() {
	emake DESTDIR="${D}" LOCALES="${LINGUAS}" PREFIX=/usr SYSCONFDIR=/etc \
		PERL_INSTALLDIRS=vendor MANDIR=/usr/share/man \
		install install-doc install-man DOCDIR=/usr/share/doc/${PF}/html/
	perl_delete_localpod
	dodoc README llgalrc llgalrc.5
}
