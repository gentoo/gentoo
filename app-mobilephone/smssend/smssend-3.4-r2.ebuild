# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Universal SMS sender"
# Was: http://zekiller.skytech.org/smssend_menu_en.html
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

# -r5 of skyutils fixes a runtime crash, bug 588326.
# Without SSL support in skyutils, some providers fail.
DEPEND=">=dev-libs/skyutils-2.8-r5[ssl]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-verizon.diff" )

src_prepare() {
	default

	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.in \
		|| die 'failed to rename AM_CONFIG_HEADER macro'

	eautoreconf
}
