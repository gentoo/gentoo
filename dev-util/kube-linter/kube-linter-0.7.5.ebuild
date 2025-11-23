# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="kubernetes yaml and helm chart static analysis tool"
HOMEPAGE="https://kubelinter.io"
SRC_URI="https://github.com/stackrox/kube-linter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

QA_PRESTRIPPED=usr/bin/kube-linter

src_prepare() {
	default
	sed -i -e "s/-race//" Makefile || die
}

src_compile() {
	ego build -o kube-linter ./cmd/kube-linter
}

src_install() {
	dobin kube-linter
		dodoc -r config.yaml.example docs/*
}

src_test() {
	emake test
}
