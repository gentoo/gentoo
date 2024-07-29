# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Podcast client for the command-line written in Ruby"
HOMEPAGE="http://podcatcher.rubyforge.org/"
SRC_URI="http://rubyforge.org/frs/download.php/76053/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-lang/ruby"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	dobin bin/podcatcher
	dodoc -r demo/.
}
