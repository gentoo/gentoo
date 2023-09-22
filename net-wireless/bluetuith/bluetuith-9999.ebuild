# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A TUI bluetooth manager for Linux written in Go"
HOMEPAGE="https://darkhz.github.io/bluetuith"

GIT_DOCUMENTATION_COMMIT="9c215bb1a64bdbf0f88060db4de6701215799033"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/darkhz/bluetuith.git"
else
	SRC_URI="https://github.com/darkhz/bluetuith/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" https://github.com/rahilarious/gentoo-distfiles/releases/download/${P}/deps.tar.xz -> ${P}-deps.tar.xz"
	SRC_URI+=" https://github.com/darkhz/bluetuith/archive/${GIT_DOCUMENTATION_COMMIT}.tar.gz -> ${P}-docs.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0 BSD-2 BSD MIT"
SLOT="0"

IUSE="doc"
RESTRICT="test"
RDEPEND="
	net-wireless/bluez
"

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		# unpack code
		git-r3_src_unpack

		# unpack docs
		EGIT_BRANCH="documentation"
		git-r3_fetch
		EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-${GIT_DOCUMENTATION_COMMIT}"
		git-r3_checkout

		go-module_live_vendor
	else
		go-module_src_unpack
	fi
}

src_compile() {
	ego build
}

src_test() {
	ego test ./...
}

src_install() {
	default
	dobin "${PN}"
	dodoc -r ../"${PN}-${GIT_DOCUMENTATION_COMMIT}"/documentation/*.md
	use doc && docinto html && dodoc -r ../"${PN}-${GIT_DOCUMENTATION_COMMIT}"/docs/*
}
