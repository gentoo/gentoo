# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Window Maker dock application showing incoming mail"
HOMEPAGE="https://www.dockapps.net/wmail"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND=">=x11-libs/libdockapp-0.7:="
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README wmailrc-sample)

src_configure() {
	econf --enable-delt-xpms
}
