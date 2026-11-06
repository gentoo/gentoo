# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit toolchain-funcs

MY_PN="ecm"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Elliptic Curve Method for Integer Factorization"
HOMEPAGE="https://gitlab.inria.fr/zimmerma/ecm"
SRC_URI="https://gitlab.inria.fr/-/project/24244/uploads/0cfe6c56d11fc01c98a193fabdbd015c/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86 ~x64-macos"
IUSE="+custom-tune openmp cpu_flags_x86_sse2"

# libprimesieve is technically optional but the check for it is
# automagic, and it will speed things up anyway, so let's just
# require it.
DEPEND="dev-libs/gmp:=
	sci-mathematics/primesieve:="
RDEPEND="${DEPEND}"

# xsltproc is used to produce the manppage in combination with the
# appropriate stylesheet
BDEPEND="dev-libs/libxslt
	app-text/docbook-xsl-stylesheets"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
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
		$(use_enable openmp) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable custom-tune asm-redc)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
