# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P=${P/_/}

DESCRIPTION="CMU Speech Recognition-engine"
HOMEPAGE="https://cmusphinx.github.io"
SRC_URI="mirror://sourceforge/cmusphinx/${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DOCS=( AUTHORS ChangeLog README NEWS
	   doc/{README.{bin,lib},SCHMM_format,filler.dict,phoneset{,-old}} )
HTML_DOCS=( doc/{phoneset_s2,sphinx2}.html )

PATCHES=( "${FILESDIR}"/${P}-as-needed.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default

	rm -r "${ED}/usr/share/${PN}/doc" || die
	find "${ED}" -name '*.la' -delete || die
}
