# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="A tool for building, changing, and combining infrastructure safely"
HOMEPAGE="https://www.terraform.io/"
SRC_URI="https://github.com/hashicorp/terraform/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD-4 ISC JSON MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT+=" test"

DOCS=( {README,CHANGELOG}.md )

src_compile() {
	CGO_ENABLED=0 go build \
		-ldflags "-s -w" \
		-mod vendor \
		-o "bin/${PN}" ./ || die
}

src_install() {
	dobin bin/terraform

	einstalldocs
}

pkg_postinst() {
	elog "If you would like to install shell completions please run:"
	elog "    terraform -install-autocomplete"
}
