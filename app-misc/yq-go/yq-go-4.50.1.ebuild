# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="yq is a lightweight and portable command-line YAML, JSON and XML processor"
HOMEPAGE="https://github.com/mikefarah/yq"
SRC_URI="https://github.com/mikefarah/yq/archive/refs/tags/v${PV}.tar.gz -> ${P/-go/}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/yq/releases/download/v${PV}/${P/-go/}-vendor.tar.xz"
S=${WORKDIR}/${P/-go/}

LICENSE="MIT"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong"
IUSE="+yq-symlink"

RDEPEND="yq-symlink? ( !app-misc/yq[yq-symlink(+)] )"

DOCS=( README.md )

src_compile() {
	CGO_ENABLED=0 ego build -ldflags "-X main.GitDescribe=v${PV} -w"
}

src_test() {
	./scripts/test.sh || die
}

src_install() {
	einstalldocs
	newbin yq yq-go
	use yq-symlink && dosym yq-go /usr/bin/yq
}
