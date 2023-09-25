# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Checks if Gentoo go packages are compiled with the system's golang version"
HOMEPAGE="https://github.com/mrueg/go-updater"
SRC_URI="https://github.com/mrueg/go-updater/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-go/goversion"

src_compile() { :; }

src_install() {
	dobin "${PN}"
	dodoc README.md
}
