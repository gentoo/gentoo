# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils flag-o-matic libtool

DESCRIPTION="A library for manipulating FlashPIX images"
HOMEPAGE="https://github.com/ImageMagick/libfpx"
SRC_URI="mirror://imagemagick/delegates/${P/_p/-}.tar.bz2"

LICENSE="Flashpix"
SLOT="0/1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="static-libs"

S=${WORKDIR}/${P/_p/-}

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.0.13-export-symbols.patch
)

src_prepare() {
	default

	# we're not windows, even though we don't define __unix by default
	[[ ${CHOST} == *-darwin* ]] && append-flags -D__unix

	elibtoolize
}

src_configure() {
	append-ldflags -Wl,--no-undefined
	econf \
		$(use_enable static-libs static) \
		LIBS="-lstdc++ -lm"
}

src_install() {
	default

	dodoc AUTHORS ChangeLog doc/*.txt

	insinto /usr/share/doc/${PF}/pdf
	doins doc/*.pdf
}
