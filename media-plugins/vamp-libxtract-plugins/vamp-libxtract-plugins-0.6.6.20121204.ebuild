# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2
inherit eutils multilib toolchain-funcs

DESCRIPTION="Vamp plugin encapsulating many of the functions of the LibXtract library"
HOMEPAGE="http://www.vamp-plugins.org/"
SRC_URI="http://code.soundsoftware.ac.uk/attachments/download/618/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE=""

RDEPEND="=sci-libs/fftw-3*
	>=media-libs/libxtract-0.6.6
	media-libs/vamp-plugin-sdk"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e "s/-O3//" -e "s/ -Wl,-Bstatic//" -i Makefile
}

src_compile() {
	tc-export CXX
	emake || die "emake failed"
}

src_install() {
	insinto /usr/$(get_libdir)/vamp
	doins vamp-libxtract.{so,cat} || die "doins failed"
	dodoc README STATUS
}
