# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit toolchain-funcs python-single-r1

DESCRIPTION="Genome-scale comparison of biological sequences"
HOMEPAGE="http://last.cbrc.jp/"
SRC_URI="http://last.cbrc.jp/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${PN}-299-fix-build-system.patch
	"${FILESDIR}"/${PN}-299-portable-shebangs.patch
)

src_configure() {
	tc-export CC CXX
}

src_install() {
	local DOCS=( doc/*.txt ChangeLog.txt README.txt )
	local HTML_DOCS=( doc/*html )
	einstalldocs

	dobin src/last{al,db,ex}

	cd scripts || die
	local i
	for i in *py; do
		newbin ${i} ${i%.py}
	done
	dobin *sh
}
