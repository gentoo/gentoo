# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/garybernhardt/selecta"
else
	SRC_URI="https://github.com/garybernhardt/selecta/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A fuzzy text selector for files and anything else you need to select"
HOMEPAGE="https://github.com/garybernhardt/selecta"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=dev-lang/ruby-1.9.3"

src_install() {
	dobin selecta
	einstalldocs
}
