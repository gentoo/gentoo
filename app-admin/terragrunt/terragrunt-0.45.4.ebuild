# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Terragrunt is a thin wrapper for Terraform"
HOMEPAGE="https://terragrunt.gruntwork.io/"
SRC_URI="https://github.com/gruntwork-io/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

DEPEND="dev-lang/go"
RDEPEND="app-admin/terraform"

RESTRICT="test"

src_prepare() {
	default
}

src_compile() {
	local go_ldflags
	go_ldflags="-X main.VERSION=${PV}"
	CGO_ENABLED=1 \
		ego build \
		-ldflags "${go_ldflags}" \
		-trimpath \
		-o bin/${PN}
}

src_install() {
	dobin bin/${PN}
}
