# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

go-module_set_globals

DESCRIPTION="The Symfony CLI tool"
HOMEPAGE="https://github.com/symfony-cli/symfony-cli"
LICENSE="Apache-2.0 BSD MIT AGPL-3 MPL-2.0"
SRC_URI="https://github.com/symfony-cli/symfony-cli/archive/v5.4.9.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://www.eclixo.com/storage/portage/symfony-cli-5.4.9-deps.tar.xz"
SLOT="0"
KEYWORDS="~amd64"
DOCS=(
	README.md
)

src_compile() {
	ego build -o symfony .
}

src_install() {
	dobin symfony
	einstalldocs
}
