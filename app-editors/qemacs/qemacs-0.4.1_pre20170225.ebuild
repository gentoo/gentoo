# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="QEmacs is a very small but powerful UNIX editor"
HOMEPAGE="https://savannah.nongnu.org/projects/qemacs/"
# snapshot of http://cvs.savannah.gnu.org/viewvc/?root=qemacs
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="LGPL-2.1+ GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="X png unicode xv"
RESTRICT="test"

RDEPEND="
	X? ( x11-libs/libX11
		x11-libs/libXext
		xv? ( x11-libs/libXv ) )
	png? ( >=media-libs/libpng-1.2:0= )"

DEPEND="${RDEPEND}
	>=app-text/texi2html-5"

S="${WORKDIR}/${PN}"

src_prepare() {
	eapply "${FILESDIR}/${P}-Makefile.patch"
	eapply "${FILESDIR}/${P}-nostrip.patch"
	eapply_user

	# Change the manpage to reference a /real/ file instead of just an
	# approximation.  Purely cosmetic!
	eapply "${FILESDIR}/${P}-manpage.patch"
	sed -i -e "s:@PF@:${PF}:" qe.1 || die
}

src_configure() {
	# Home-grown configure script, doesn't support most standard options
	./configure \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--cc="$(tc-getCC)" \
		$(use_enable X x11) \
		$(use_enable png) \
		$(use_enable xv) || die
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc Changelog README TODO.org config.eg
	docinto html
	dodoc qe-doc.html

	# Install headers so users can build their own plugins
	insinto /usr/include/qe
	doins *.h
	insinto /usr/include/qe/libqhtml
	doins libqhtml/*.h
}
