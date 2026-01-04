# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

# This can't work forever; but for now, it's better than hard-coding the
# correct version string.
MY_PV="${PV:0:1}.${PV:1}"
QA_PKGCONFIG_VERSION="${MY_PV}"

MY_P="${PN}-${MY_PV}"
DESCRIPTION="C library implementing the Double Description Method"
HOMEPAGE="https://people.inf.ethz.ch/fukudak/cdd_home/index.html"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${MY_PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~riscv ~x86"
IUSE="doc examples static-libs tools"

DEPEND="dev-libs/gmp:0"
RDEPEND="dev-libs/gmp:0="

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	if ! use tools; then
		rm "${ED}"/usr/bin/* || die
	fi

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi

	# Nobody wants the dvi/ps manual...
	rm "${ED}/usr/share/doc/${PF}"/cddlibman.{dvi,ps} || die

	# since the PDF manual is installed by default.
	if ! use doc; then
		rm "${ED}/usr/share/doc/${PF}"/cddlibman.pdf || die
	fi

	# The docs and examples are *both* installed by default, so we
	# have to remove the examples if the user doesn't want them.
	docompress -x "/usr/share/doc/${PF}"/examples{,-ext,-ine,-ine3d}
	if ! use examples; then
		rm -r "${ED}/usr/share/doc/${PF}"/examples{,-ext,-ine,-ine3d} || die
	fi
}
