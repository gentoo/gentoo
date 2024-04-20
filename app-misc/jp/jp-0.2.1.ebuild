# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="Command line interface to JMESPath"
HOMEPAGE="https://github.com/jmespath/jp http://jmespath.org"
SRC_URI="https://github.com/jmespath/jp/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="jpp"
RESTRICT+=" test"
# The jpp flag is deprecated (see jpipe for jpp).
REQUIRED_USE="!jpp"
RDEPEND="!app-misc/jpipe[jp-symlink]"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	eapply "${FILESDIR}/${P}-tidy.patch"
}

src_compile() {
	go build -mod=readonly -o ./jp ./jp.go || die
}

src_install() {
	dobin jp
	dodoc README.md
}
