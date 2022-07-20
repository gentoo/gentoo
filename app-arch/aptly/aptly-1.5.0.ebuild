# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd

DESCRIPTION="Debian repository management tool"
HOMEPAGE="https://www.aptly.info/"

SRC_URI="https://github.com/aptly-dev/aptly/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="MIT Apache-2.0 BSD BSD-2 ISC MPL-2.0 WTFPL-2 ZLIB"
RESTRICT+=" test"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake install
}

src_install() {
	dobin ~/go/bin/aptly
	dodoc README.rst
	systemd_dounit aptly.service aptly-api.service
}
