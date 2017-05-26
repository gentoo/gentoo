# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="File comparision, ignoring small numeric differences and formats"
HOMEPAGE="http://www.nongnu.org/numdiff/"
SRC_URI="http://savannah.nongnu.org/download/numdiff/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+nls +gmp"

RDEPEND="
	gmp? ( dev-libs/gmp:0 )
	nls? ( sys-devel/gettext )
	!dev-util/ndiff"

DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=(
		$(use_enable gmp)
		$(use_enable nls)
	    --enable-optimization
	)
	econf ${myeconfargs[@]}
}

src_install() {
	default

	# Remove some empty folders:
	rm -r "${ED}"/usr/share/locale || die

	#Fix up wrong installation paths:
	mv "${ED}"/usr/share/doc/${P}/{numdiff/numdiff.{html,pdf,txt*},} || die
	rm -r "${ED}"/usr/share/doc/${P}/numdiff || die
}
