# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple scripts for converting xml to groff or html"
HOMEPAGE="https://sourceforge.net/projects/xmltoman/"
SRC_URI="https://github.com/atsb/xmltoman/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-lang/perl
	dev-perl/XML-Parser
"

PATCHES=(
	"${FILESDIR}"/${P}-generate-man-pages.patch
)

src_install() {
	# 'make install' requires GNU install, upstream is dead and carrying
	# a patch is more space than redoing it here
	dobin xmltoman xmlmantohtml

	insinto /usr/share/xmltoman
	doins xmltoman.{css,dtd,xsl}

	dodoc README
	doman xmltoman.1 xmlmantohtml.1
}
