# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Almost lossless JPEG pixel interpolator, for correcting digital camera defects"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="media-libs/libjpeg-turbo:="
DEPEND="${RDEPEND}"

src_prepare() {
	default

	eautoreconf #870733
}

src_install() {
	dobin jpeg{hotp,pixi}
	doman man/jpeg{hotp,pixi}.1
	einstalldocs
}
