# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-base go-module

DESCRIPTION="A tool for building, changing, and combining infrastructure safely"
HOMEPAGE="https://www.terraform.io/"

EGO_PN="github.com/hashicorp/${PN}"
SRC_URI="https://github.com/hashicorp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD-4 ECL-2.0 imagemagick ISC JSON MIT MIT-with-advertising MPL-2.0 unicode"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

DOCS=( {README,CHANGELOG}.md )

src_prepare() {
	default
	# the sed command is necessary to generate tests outside of the
	# default git root of `terraform', in our case the working dir
	# is `work/$PN-$PV'
	# sed -i -e "s/!=\s\+\"terraform\"/!=\ \"${P}\"/" \
	# 	./scripts/generate-plugins.go || die
}

src_compile() {
	GOCACHE="${T}/go-cache" go build \
		-mod vendor \
		-work -o "bin/${PN}" ./ || die
}

src_install() {
	dobin bin/terraform

	einstalldocs
}

pkg_postinst() {
	elog "If you would like to install shell completions please run:"
	elog "    terraform -install-autocomplete"
}
