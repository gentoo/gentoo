# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/uchardet/uchardet-0.0.1.ebuild,v 1.3 2015/04/19 07:04:41 pacho Exp $

EAPI="5"

inherit cmake-utils

DESCRIPTION="C port of Mozilla's Automatic Charset Detection algorithm"
HOMEPAGE="https://code.google.com/p/uchardet/"
SRC_URI="https://uchardet.googlecode.com/files/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	cmake-utils_src_install
	use static-libs || find "${ED}" -name '*.a' -delete
}
