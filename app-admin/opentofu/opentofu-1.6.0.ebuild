# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

# Replace the underscore with a dash to get upstream name for prereleases
MY_PV=$(ver_rs 3 -)
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A tool for building, changing, and combining infrastructure safely"
HOMEPAGE="https://opentofu.org/"
SRC_URI="https://github.com/opentofu/opentofu/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://gentoo.braindriven.dk/${P}-deps.tar.xz"

# Use upstream name for source directory
S="${WORKDIR}/${PN}-$(ver_rs 3 -)"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-lang/go"

RESTRICT="test"

DOCS=( {README,CHANGELOG}.md )

src_compile() {
	export CGO_ENABLED=0
	export GOOS=$(go env GOOS)
	export GOARCH=$(go env GOARCH)

	go build -o bin/ ./cmd/tofu || die
}

src_install() {
	dobin bin/*
	einstalldocs
}

pkg_postinst() {
	elog "If you would like to install shell completions please run:"
	elog "    tofu -install-autocomplete"
}
