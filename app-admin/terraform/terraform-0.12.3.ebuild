# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-vcs-snapshot

DESCRIPTION="A tool for building, changing, and combining infrastructure safely"
HOMEPAGE="https://www.terraform.io/"

EGO_PN="github.com/hashicorp/${PN}"
SRC_URI="https://github.com/hashicorp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND=">=dev-lang/go-1.11.0"

DOCS=( src/${EGO_PN}/{README,CHANGELOG}.md )

src_compile() {
	cd "src/${EGO_PN}" || die
	GOPATH="${S}" GOCACHE="${T}/go-cache" go build \
		-v -work -o "${S}/${PN}" ./ || die
}

src_install() {
	dobin terraform

	einstalldocs
}

pkg_postinst() {
	elog "If you would like to install shell completions please run:"
	elog "    terraform -install-autocomplete"
}
