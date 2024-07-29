# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

EGIT_COMMIT="cffed372371dcbea3dc9a646ce5a913fc1c09513"

DESCRIPTION="Docker-compatible CLI for containerd, with support for Compose"
HOMEPAGE="https://github.com/containerd/nerdctl"
SRC_URI="
	https://github.com/containerd/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/containerd/${PN}/releases/download/v${PV}/${P}-go-mod-vendor.tar.gz
"

LICENSE="Apache-2.0"
LICENSE+=" BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="rootless"

DEPEND="
	rootless? (
		app-containers/slirp4netns
		sys-apps/rootlesskit
	)
"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}"
	unpack "${P}-go-mod-vendor.tar.gz"
}

src_compile() {
	emake VERSION=v${PV} REVISION="${EGIT_COMMIT}"
}

src_install() {
	local emake_args=(
		DESTDIR="${D}"
		VERSION=v${PV}
		REVISION="${EGIT_COMMIT}"
		DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		PREFIX="${EPREFIX}/usr"
		install
	)
	emake "${emake_args[@]}"
	DOCS=( README.md docs/* examples )
	einstalldocs
}
