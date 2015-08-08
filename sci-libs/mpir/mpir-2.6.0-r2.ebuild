# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils eutils toolchain-funcs

DESCRIPTION="Library for arbitrary precision integer arithmetic (fork of gmp)"
HOMEPAGE="http://www.mpir.org/"
SRC_URI="http://www.mpir.org/${P}.tar.lzma"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+cxx cpudetection static-libs"

DEPEND="x86? ( dev-lang/yasm )
	amd64? ( dev-lang/yasm )"
RDEPEND=""

src_prepare() {
	tc-export CC
	epatch \
		"${FILESDIR}"/${PN}-2.6.0-yasm.patch \
		"${FILESDIR}"/${PN}-1.3.0-ABI-multilib.patch \
		"${FILESDIR}"/${PN}-2.5.1-automake-1.12.patch \
		"${FILESDIR}"/${PN}-2.6.0-gcc48.patch

	# In the same way there was QA regarding executable stacks
	# with GMP we have some here as well. We cannot apply the
	# GMP solution as yasm is used, at least on x86/amd64.
	# Furthermore we are able to patch config.ac.
	ebegin "Patching assembler files to remove executable sections"
	local i
	for i in $(find . -type f -name '*.asm') ; do
		cat >> $i <<-EOF
			#if defined(__linux__) && defined(__ELF__)
			.section .note.GNU-stack,"",%progbits
			#endif
		EOF
	done

	for i in $(find . -type f -name '*.as') ; do
		cat >> $i <<-EOF
			%ifidn __OUTPUT_FORMAT__,elf
			section .note.GNU-stack noalloc noexec nowrite progbits
			%endif
		EOF
	done
	eend
	eautoreconf
}

src_configure() {
	# beware that cpudetection aka fat binaries is x86/amd64 only.
	# Place mpir in profiles/arch/$arch/package.use.mask
	# when making it available on $arch.
	myeconfargs+=(
		$(use_enable cxx)
		$(use_enable cpudetection fat)
	)
	autotools-utils_src_configure
}
