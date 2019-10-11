# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit font

DESCRIPTION="TeX's Computer Modern Fonts for MathML"
HOMEPAGE="http://www.mozilla.org/projects/mathml/fonts/"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.zip"

LICENSE="bakoma"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}/${PN}
FONT_S=${WORKDIR}/${PN}
FONT_SUFFIX="ttf"
