# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils multilib

DESCRIPTION="Tools for accessing and converting various ebook file formats"
HOMEPAGE="http://sourceforge.net/projects/ebook-tools"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-fbsd"
IUSE="+lit2epub"

DEPEND="
	dev-libs/libxml2
	dev-libs/libzip
"
RDEPEND="${DEPEND}
	lit2epub? ( app-text/convertlit	)
"

DOCS=( INSTALL README TODO )

src_prepare() {
	default

	use lit2epub || sed -i -e '\|lit2epub|d' -- 'src/tools/CMakeLists.txt' || die
}
