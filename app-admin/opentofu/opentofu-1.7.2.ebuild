# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="The open source infrastructure as code tool"
HOMEPAGE="https://www.opentofu.org/"
SRC_URI="https://github.com/opentofu/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MPL-2.0 MIT ISC"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-go/gox"

RESTRICT="test"

DOCS=( {README,CHANGELOG}.md )

src_compile() {
	export CGO_ENABLED=0
	gox \
		-os=$(go env GOOS) \
		-arch=$(go env GOARCH) \
		-output bin/tofu \
		-verbose \
		./cmd/tofu || die
}

src_install() {
	dobin bin/*
	einstalldocs
}

pkg_postinst() {
	elog "If you would like to install shell completions please run:"
	elog "    tofu -install-autocomplete"
}
