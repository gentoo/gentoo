# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="JSON module for Guile"
HOMEPAGE="https://savannah.nongnu.org/projects/guile-json/"
SRC_URI="http://download.savannah.nongnu.org/releases/guile-json/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-scheme/guile-2.0.0"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# http://debbugs.gnu.org/cgi/bugreport.cgi?bug=38112
	find "${S}" -name "*.scm" -exec touch {} + || die
}
