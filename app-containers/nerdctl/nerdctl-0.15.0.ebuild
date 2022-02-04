# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="Docker-compatible CLI for containerd, with support for Compose"
HOMEPAGE="https://github.com/containerd/nerdctl"

EGIT_COMMIT="b72b5ca14550b2e23a42787664b6182524c5053f"
# There are too many vendor dependencies to distribute via EGO_SUM (see https://bugs.gentoo.org/721088),
# so they are instead distributed via a combined tarball.
SRC_URI="https://github.com/zmedico/nerdctl/archive/refs/tags/v${PV}-vendor.tar.gz -> ${P}-vendor.tar.gz"
BDEPEND=">=dev-lang/go-1.16"
LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"

KEYWORDS="~amd64"
IUSE=""
S=${WORKDIR}/${P}-vendor

src_prepare() {
	sed -e 's:/usr/local/bin:/usr/bin:' \
		-e "s|^VERSION[[:space:]]*=.*|VERSION := v${PV}|" \
		-e "s|^REVISION[[:space:]]*=.*|REVISION := ${EGIT_COMMIT}|" \
		-i Makefile || die
	default
}

src_install() {
	DOCS=(README.md docs examples)
	default_src_install
}
