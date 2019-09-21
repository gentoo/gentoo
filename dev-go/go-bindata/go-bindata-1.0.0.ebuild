# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/go-bindata/go-bindata/..."
KEYWORDS="amd64 ~arm ~arm64"

DESCRIPTION="A small utility which generates Go code from any file"
HOMEPAGE="https://github.com/go-bindata/go-bindata"
SRC_URI="https://github.com/go-bindata/go-bindata/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="CC-PD"
SLOT="0/${PVR}"

src_install() {
	GOBIN=${S}/bin \
		golang-build_src_install
	dobin bin/*
}
