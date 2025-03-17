# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="Library that renders module files to PCM data"
HOMEPAGE="https://github.com/libxmp/libxmp"
SRC_URI="https://github.com/libxmp/libxmp/releases/download/${P}/${P}.tar.gz"

LICENSE="LGPL-2.1+ MIT 0BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc64 ~riscv sparc x86"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	emake V=1
}
