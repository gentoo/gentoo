# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs

DESCRIPTION="Library for arbitrary precision integer arithmetic (fork of gmp)"
HOMEPAGE="http://www.mpir.org/"
SRC_URI="http://www.mpir.org/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0/23"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh x86 ~amd64-linux ~x86-linux"
IUSE="+cxx cpudetection static-libs"

DEPEND="
	x86? ( dev-lang/yasm )
	amd64? ( dev-lang/yasm )
	amd64-fbsd? ( dev-lang/yasm )
"
RDEPEND=""

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
	local myeconfargs=(
		$(use_enable cxx)
		$(use_enable cpudetection fat)
		$(use_enable static-libs static)
	)
	# https://bugs.gentoo.org/661430
	if !use amd64 && !use x86; then
		myeconfargs+=( --with-yasm=/bin/false )
	fi
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/*la
}
