# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit bash-completion-r1 flag-o-matic go-module

DESCRIPTION="GitHub CLI"
HOMEPAGE="https://github.com/cli/cli"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cli/cli.git"
else
	SRC_URI="https://github.com/cli/cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv"
	S="${WORKDIR}/cli-${PV}"
fi

LICENSE="MIT Apache-2.0 BSD BSD-2 MPL-2.0"
SLOT="0"

RDEPEND=">=dev-vcs/git-1.7.3"

RESTRICT="test"

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		go-module_src_unpack
	fi
}

src_compile() {
	[[ ${PV} == *9999 ]] || export GH_VERSION="v${PV}"
	# Filter LTO flags to avoid build failures.
	filter-lto
	# Filter '-ggdb3' flag to avoid build failures. bugs.gentoo.org/847991
	filter-flags "-ggdb3"
	# Go LDFLAGS are not the same as GCC/Binutils LDFLAGS
	unset LDFLAGS
	# Once we set up cross compiling, this line will need to be adjusted
	# to compile for the target.
	# Everything else in this function happens on the host.
	emake

	einfo "Building man pages"
	emake manpages

	einfo "Building completions"
	go run ./cmd/gh completion -s bash > gh.bash-completion || die
	go run ./cmd/gh completion -s zsh > gh.zsh-completion || die
}

src_install() {
	dobin bin/gh
	dodoc README.md

	doman share/man/man?/gh*.?

	newbashcomp gh.bash-completion gh
	insinto /usr/share/zsh/site-functions
	newins gh.zsh-completion _gh
}
