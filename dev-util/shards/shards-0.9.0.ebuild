# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Dependency manager for the Crystal language"
HOMEPAGE="https://github.com/crystal-lang/shards"
SRC_URI="https://github.com/crystal-lang/shards/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>dev-lang/crystal-0.11.1[yaml]
"
RDEPEND="${DEPEND}"

RESTRICT=test # missing files in tarball

src_install() {
	dobin bin/${PN}
	dodoc README.md
}
