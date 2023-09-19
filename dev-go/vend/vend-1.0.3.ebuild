# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="dependency vendor for Go programs"
HOMEPAGE="https://github.com/nomad-software/vend"
SRC_URI="https://github.com/nomad-software/vend/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~s390 ~x86"
src_compile() {
	ego build .
}

src_install() {
	dobin vend
	einstalldocs
}
