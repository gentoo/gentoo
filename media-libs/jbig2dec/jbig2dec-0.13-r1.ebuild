# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A decoder implementation of the JBIG2 image compression format"
HOMEPAGE="http://ghostscript.com/jbig2dec.html"
SRC_URI="http://downloads.ghostscript.com/public/${PN}/${P}.tar.gz
	test? ( http://jbig2dec.sourceforge.net/ubc/jb2streams.zip )"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x86-solaris"
IUSE="png static-libs test"

RDEPEND="png? ( media-libs/libpng:0= )"
DEPEND="${RDEPEND}
	test? ( app-arch/unzip )"

RESTRICT="test"
# bug 324275

DOCS="CHANGES README"

PATCHES=(
	"${FILESDIR}/${P}-CVE-2016-9601.patch"
)

src_prepare() {
	default

	if use test; then
		mkdir "${WORKDIR}/ubc" || die
		mv -v "${WORKDIR}"/*.jb2 "${WORKDIR}/ubc/" || die
		mv -v "${WORKDIR}"/*.bmp "${WORKDIR}/ubc/" || die
	fi
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with png libpng)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm {} + || die
}
