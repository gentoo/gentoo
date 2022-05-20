# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Library for arbitrary precision integer arithmetic (fork of gmp)"
HOMEPAGE="http://www.mpir.org/"
SRC_URI="http://www.mpir.org/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0/23"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="+cxx cpudetection"

BDEPEND="
	x86? ( dev-lang/yasm )
	amd64? ( dev-lang/yasm )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.7.2-ABI-multilib.patch
)

src_prepare() {
	tc-export CC

	default

	# In the same way there was QA regarding executable stacks
	# with GMP we have some here as well. We cannot apply the
	# GMP solution as yasm is used, at least on x86/amd64.
	# Furthermore we are able to patch config.ac.
	einfo "Patching assembler files to remove executable sections"
	local i
	for i in $(find . -type f -name '*.asm') ; do
		cat >> $i <<-EOF || die

			#if defined(__linux__) && defined(__ELF__)
			.section .note.GNU-stack,"",%progbits
			#endif
		EOF
	done

	for i in $(find . -type f -name '*.as') ; do
		cat >> $i <<-EOF || die

			%ifidn __OUTPUT_FORMAT__,elf
			section .note.GNU-stack noalloc noexec nowrite progbits
			%endif
		EOF
	done

	eautoreconf
}

src_configure() {
	# beware that cpudetection aka fat binaries is x86/amd64 only.
	# Place mpir in profiles/arch/$arch/package.use.mask
	# when making it available on $arch.
	local myeconfargs=(
		$(use_enable cxx)
		$(use_enable cpudetection fat)
		--disable-static
	)
	# https://bugs.gentoo.org/661430
	if ! use amd64 && ! use x86; then
		myeconfargs+=( --with-yasm="${BROOT}"/bin/false )
	fi
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
