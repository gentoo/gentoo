# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Metapackage for pandoc version 3"
HOMEPAGE="https://pandoc.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="app-text/pandoc-cli"

pkg_postinst() {
	elog "The pandoc CLI executable has been split off upstream into a new"
	elog "package named pandoc-cli, starting with pandoc version 3."
	elog "This metapackage ${CATEGORY}/${P} was created to ease upgrading,"
	elog "but it is recommended to switch to ${CATEGORY}/pandoc-cli."
}
