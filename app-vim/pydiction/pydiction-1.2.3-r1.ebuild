# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit vim-plugin python-r1

DESCRIPTION="vim plugin: tab-complete your Python code"
HOMEPAGE="https://rkulla.github.io/pydiction/"
SRC_URI="https://dev.gentoo.org/~monsieurp/packages/${P}.zip"

LICENSE="vim"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="app-arch/unzip"
RDEPEND="${PYTHON_DEPS}"

S="${WORKDIR}/${PN}-master"

src_install() {
	insinto "/usr/share/${PN}"
	local pyfiles=( complete-dict pydiction.py )
	doins "${pyfiles[@]}"
	rm -v "${pyfiles[@]}" || die
	vim-plugin_src_install
}
