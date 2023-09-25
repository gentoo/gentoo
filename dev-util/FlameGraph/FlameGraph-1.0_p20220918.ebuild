# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Visualization of hierarchical data, especially profiled stack traces"
HOMEPAGE="https://www.brendangregg.com/flamegraphs.html https://github.com/brendangregg/FlameGraph"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/brendangregg/FlameGraph.git"
else
	COMMIT_ID="d9fcc272b6a08c3e3e5b7919040f0ab5f8952d65"
	SRC_URI="https://github.com/brendangregg/FlameGraph/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="CDDL"
SLOT="0"

S="${WORKDIR}/${PN}-${COMMIT_ID}"

RDEPEND="
	dev-lang/perl
	app-alternatives/awk
"

src_test() {
	./test.sh || die
}

src_install() {
	dobin *.pl *.awk
	dodoc README.md
}
