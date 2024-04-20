# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mate-desktop.org

	KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"

DESCRIPTION="Common files for development of MATE packages"
LICENSE="GPL-3+"
SLOT="0"

src_prepare() {
	default
}

src_install() {
	mv doc-build/README README.doc-build \
		|| die "Failed to rename doc-build/README."

	default

	dodoc doc/usage.txt
}
