# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Encoding, decoding, and sending of MMS:es"
HOMEPAGE="https://www.hellkvist.org/software/#MMSLIB"
SRC_URI="https://www.hellkvist.org/software/mmslib/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="dev-lang/php:*"

src_install() {
	insinto "/usr/share/php/mmslib"
	doins mmslib.php

	einstalldocs
	use examples && dodoc -r samples content
}
