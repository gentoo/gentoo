# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Visualization of hierarchical data, especially profiled stack traces"
HOMEPAGE="https://www.brendangregg.com/flamegraphs.html https://github.com/brendangregg/FlameGraph"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/brendangregg/FlameGraph.git"
else
	SRC_URI="https://github.com/brendangregg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="CDDL"
SLOT="0"

RDEPEND="
	dev-lang/perl
	virtual/awk
"

src_test() {
	./test.sh || die
}

src_install() {
	dobin *.pl *.awk
	dodoc README.md
}
