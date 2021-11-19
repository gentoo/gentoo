# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

MY_PN="ecm"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Elliptic Curve Method for Integer Factorization"
HOMEPAGE="https://gitlab.inria.fr/zimmerma/ecm"
SRC_URI="https://gitlab.inria.fr/zimmerma/ecm/uploads/9cd422ec80268f8a885e499e17f98056/${MY_P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86 ~ppc-macos ~x64-macos"
IUSE="+custom-tune openmp static-libs cpu_flags_x86_sse2"

DEPEND="dev-libs/gmp:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.4-openmp.patch
	"${FILESDIR}"/${PN}-7.0.4-execstack.patch
)

S="${WORKDIR}/${MY_P}"

pkg_pretend() {
	use openmp && tc-check-openmp
}

src_prepare(){
	default

	# patch the asm files
	# create a sample with the assembly code needed
	# Quote around # are needed because the files will be processed by M4.
	cat <<-EOF > "${T}/sample.asm"
	
	\`#'if defined(__linux__) && defined(__ELF__)
	.section .note.GNU-stack,"",%progbits
	\`#'endif
	EOF

	# patch the asm files
	cat "${T}/sample.asm" >> x86_64/mulredc1.asm
	for i in {2..20} ; do
		cat "${T}/sample.asm" >> x86_64/mulredc"$i".asm
		cat "${T}/sample.asm" >> x86_64/mulredc1_"$i".asm
	done

	eautoreconf
}

src_compile() {
	default
	if use custom-tune; then
		# One "emake" was needed to build the library. Now we can find
		# the best set of parameters, and then run "emake" one more time
		# to rebuild the library with the custom parameters. See the
		# project's README or INSTALL-ecm. The build targets don't depend
		# on ecm-params.h, so we need to "make clean" to force a rebuild.
		emake ecm-params && emake clean && emake
	fi
}
src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable openmp) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable custom-tune asm-redc)
}

src_install() {
	default

	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
