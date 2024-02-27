# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Set of stable and portable shell scripts"
HOMEPAGE="https://www.gnu.org/software/shtool/shtool.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ia64 ppc ~s390 sparc x86"

DEPEND="dev-lang/perl"
DOCS=( AUTHORS ChangeLog README THANKS VERSION NEWS RATIONAL )

src_prepare() {
	default
	sed -i "s|opt_C=\"ar\"|opt_C=\"$(tc-getAR)\"|g" sh.arx || die
}
