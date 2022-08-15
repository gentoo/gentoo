# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 edo go-module

DESCRIPTION="Reports on the licenses used by a Go package and its dependencies"
HOMEPAGE="https://github.com/google/go-licenses"
SRC_URI="https://github.com/google/go-licenses/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD-2 BSD MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64"

# Wants network access
RESTRICT="test"

src_compile() {
	ego build

	local shell
	for shell in bash fish zsh ; do
		edo ./go-licenses completion ${shell} > go-licenses.${shell}
	done
}

src_install() {
	einstalldocs

	dobin go-licenses

	newbashcomp ${PN}.bash ${PN}

	insinto /usr/share/fish/vendor_completions.d
	doins go-licenses.fish

	insinto /usr/share/zsh/site-functions
	newins go-licenses.zsh _go-licenses
}
