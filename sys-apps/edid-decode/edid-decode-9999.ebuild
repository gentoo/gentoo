# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 toolchain-funcs

EGIT_REPO_URI="https://git.linuxtv.org/${PN}.git"

DESCRIPTION="Decode EDID data in a human-readable format"
HOMEPAGE="https://git.linuxtv.org/edid-decode.git/"

KEYWORDS=""
LICENSE="MIT"
SLOT="0"
IUSE="examples"

src_compile() {
	tc-export CXX
	default
}

src_install() {
	emake DESTDIR="${ED}" install
	einstalldocs

	if use examples; then
		insinto /usr/share/edid-decode/examples
		doins data/*
	fi
}
