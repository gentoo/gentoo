# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-module

DESCRIPTION="Command-line static web gallery generator"
HOMEPAGE="http://bgoglin.free.fr/llgal/"
SRC_URI="https://github.com/bgoglin/llgal/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
# Package warrants IUSE doc and possibly examples
IUSE="exif"

RDEPEND="media-gfx/imagemagick
	 dev-perl/Image-Size
	 dev-perl/URI
	 dev-perl/Locale-gettext
	 exif? ( media-libs/exiftool )"

S="${WORKDIR}/${PN}-${P}"

src_compile() {
	emake \
		PREFIX="${EPREFIX}"/usr \
		SYSCONFDIR="${EPREFIX}"/etc \
		MANDIR="${EPREFIX}"/usr/share/man \
		PERL_INSTALLDIRS=vendor
	mv doc/llgalrc . || die
}

src_install() {
	emake DESTDIR="${D}" \
		LOCALES="${LINGUAS}" \
		PREFIX="${EPREFIX}"/usr \
		SYSCONFDIR="${EPREFIX}"/etc \
		MANDIR="${EPREFIX}"/usr/share/man \
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF}/html \
		PERL_INSTALLDIRS=vendor \
		install install-doc install-man
	perl_delete_localpod
	dodoc README llgalrc llgalrc.5
}
