# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="POSIX-compliant AWK interpreter written in Go, with CSV support"
HOMEPAGE="https://github.com/benhoyt/goawk"
SRC_URI="https://github.com/benhoyt/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_compile() {
	ego build
}

src_test() {
	ego test
}

src_install() {
	einstalldocs

	dobin goawk
}
