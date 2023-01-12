# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="SUID sandbox from Chromium"
HOMEPAGE="https://chromium.googlesource.com/chromium/src/+/main/docs/linux/suid_sandbox.md"
SRC_URI="https://github.com/floppym/chrome-sandbox/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

src_compile() {
	tc-export CC
	default
}

src_install() {
	local -x prefix="${EPREFIX}/usr"
	default
}
