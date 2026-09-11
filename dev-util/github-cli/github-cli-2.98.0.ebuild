# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit go-module

DESCRIPTION="GitHub CLI"
HOMEPAGE="https://github.com/cli/cli"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cli/cli.git"
else
	SRC_URI="https://github.com/cli/cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-deps.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv"
	S="${WORKDIR}/cli-${PV}"
fi

LICENSE="MIT"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0 Unlicense"
SLOT="0"
RESTRICT="test"

RDEPEND=">=dev-vcs/git-1.7.3"
BDEPEND=">=dev-lang/go-1.26.1"

PATCHES=(
	"${FILESDIR}/${PN}-2.92.0-disable-telemetry.patch"
)

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		go-module_src_unpack
	fi
}

src_compile() {
	[[ ${PV} != 9999 ]] && export GH_VERSION="v${PV}"
	emake prefix="${EPREFIX}/usr" bin/gh manpages completions
}

src_install() {
	emake prefix="${EPREFIX}/usr" DESTDIR="${D}" install
	dodoc README.md
}
