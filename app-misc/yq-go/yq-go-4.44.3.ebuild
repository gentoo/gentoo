# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="yq is a lightweight and portable command-line YAML, JSON and XML processor"
HOMEPAGE="https://github.com/mikefarah/yq"
SRC_URI="https://github.com/mikefarah/yq/archive/refs/tags/v${PV}.tar.gz -> ${P/-go/}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P/-go/}-deps.tar.xz"

S=${WORKDIR}/${P/-go/}
LICENSE="MIT"
LICENSE+=" Apache-2.0 BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~loong"
IUSE="+yq-symlink"
DOCS=(README.md)
RDEPEND="yq-symlink? ( !app-misc/yq[yq-symlink(+)] )"

src_compile() {
	CGO_ENABLED=0 ego build -ldflags "-X main.GitDescribe=v${PV} -s -w"
}

src_install() {
	einstalldocs
	newbin yq yq-go
	if use yq-symlink; then
		dosym yq-go /usr/bin/yq
	fi
}

src_test() {
	./scripts/test.sh || die
}
