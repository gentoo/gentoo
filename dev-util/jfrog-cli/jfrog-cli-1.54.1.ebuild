# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Command line utility foroperations on container images and image repositories"
HOMEPAGE="https://github.com/jfrog/jfrog-cli"
SRC_URI="https://github.com/jfrog/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	./build/build.sh || die
}

src_install() {
	dobin jfrog
	einstalldocs
}
