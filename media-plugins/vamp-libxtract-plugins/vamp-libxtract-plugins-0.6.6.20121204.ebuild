# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib toolchain-funcs

DESCRIPTION="Vamp plugin encapsulating many of the functions of the LibXtract library"
HOMEPAGE="https://www.vamp-plugins.org/"
SRC_URI="https://code.soundsoftware.ac.uk/attachments/download/618/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE=""

RDEPEND="=sci-libs/fftw-3*
	>=media-libs/libxtract-0.6.6
	media-libs/vamp-plugin-sdk"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -e "s/-O3//" -e "s/ -Wl,-Bstatic//" -i Makefile || die "sed Makefile failed"
}

src_configure() {
	tc-export CXX
}

src_install() {
	insinto /usr/$(get_libdir)/vamp
	doins vamp-libxtract.{so,cat}
	einstalldocs
}
