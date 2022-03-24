# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="LLVMgold plugin symlink for autoloading"
HOMEPAGE="https://llvm.org/"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux"

RDEPEND="sys-devel/llvm:${PV}[binutils-plugin]
	!sys-devel/llvm:0"

S=${WORKDIR}

src_install() {
	dodir "/usr/${CHOST}/binutils-bin/lib/bfd-plugins"
	dosym "../../../../lib/llvm/${PV}/$(get_libdir)/LLVMgold.so" \
		"/usr/${CHOST}/binutils-bin/lib/bfd-plugins/LLVMgold.so"
}
