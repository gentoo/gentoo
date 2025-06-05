# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 edo go-module

DESCRIPTION="A tool for building, changing, and combining infrastructure safely"
HOMEPAGE="https://www.terraform.io/"
SRC_URI="https://github.com/hashicorp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="BUSL-1.1"

# Dependent licenses
LICENSE+="  Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"

SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
RESTRICT="test"

BDEPEND="dev-go/gox"

DOCS=( {README,CHANGELOG}.md )

src_compile() {
	local -x CGO_ENABLED=0
	local gox_flags=(
		-os="$(ego env GOOS)"
		-arch="${GOARCH}"
		-ldflags="-X 'github.com/hashicorp/terraform/version.dev=no'"
		-output=bin/${PN}
		-verbose
	)
	edo gox "${gox_flags[@]}" .
}

src_install() {
	dobin bin/${PN}
	einstalldocs

	newbashcomp - "${PN}" <<- EOF
		complete -C '/usr/bin/${PN}' ${PN}
	EOF
}
