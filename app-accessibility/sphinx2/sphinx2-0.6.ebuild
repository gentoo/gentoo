# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_P=${P/_/}

DESCRIPTION="CMU Speech Recognition-engine"
HOMEPAGE="https://cmusphinx.github.io"
SRC_URI="mirror://sourceforge/cmusphinx/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="static-libs"

S=${WORKDIR}/${MY_P}
PATCHES=( "${FILESDIR}"/${P}-as-needed.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	HTML_DOCS=( doc/{phoneset_s2,sphinx2}.html )
	default
	dodoc doc/{README.{bin,lib},SCHMM_format,filler.dict,phoneset{,-old}}

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
