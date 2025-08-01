# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake dot-a

DESCRIPTION="Simple RFC-complient TELNET implementation"
HOMEPAGE="https://github.com/SDL-Hercules-390/telnet"
EGIT_REPO_URI="https://github.com/SDL-Hercules-390/telnet"

LICENSE="public-domain"
SLOT="0"
PATCHES=( "${FILESDIR}/cmakefix.patch" )

src_configure() {
	lto-guarantee-fat
	cmake_src_configure
}

src_install() {
	cmake_src_install
	strip-lto-bytecode
}
