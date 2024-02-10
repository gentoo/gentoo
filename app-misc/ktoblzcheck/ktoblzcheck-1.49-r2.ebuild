# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library to check account numbers and bank codes of German banks"
HOMEPAGE="https://ktoblzcheck.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE=""

RDEPEND="
	app-text/recode:0=
	sys-apps/grep
	sys-apps/sed
	app-alternatives/awk
	|| ( net-misc/wget www-client/lynx )
"
DEPEND="${RDEPEND}
	dev-build/libtool
"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	econf --disable-python
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
