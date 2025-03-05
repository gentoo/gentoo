# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module toolchain-funcs shell-completion

DESCRIPTION="RDAP command line client"
HOMEPAGE="
	https://www.openrdap.org/
	https://github.com/openrdap/rdap
"
SRC_URI="
	https://github.com/openrdap/rdap/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~conikost/distfiles/${P}-vendor.tar.xz
"
S=${WORKDIR}/${P/open/}

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	ego build ./cmd/rdap

	if ! tc-is-cross-compiler; then
		elog "generating shell completion files"
		# those commands exit OK with 1, so we can't use die

		./rdap --completion-script-bash > rdap.bash
		grep -q "complete -F" rdap.bash || die "bash completion script is invalid"

		./rdap --completion-script-zsh > rdap.zsh
		grep -q "compdef rdap" rdap.zsh || die "zsh completion script is invalid"
	fi
}

src_install() {
	dobin rdap
	einstalldocs

	if ! tc-is-cross-compiler; then
		newbashcomp rdap.bash rdap
		newzshcomp rdap.zsh _rdap
	else
		ewarn "Shell completion files not installed! Install them manually with '${PN} completion --help'"
	fi
}
