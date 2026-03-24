# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=fortran
FORTRAN_STANDARD=90

inherit autotools fortran-2

DESCRIPTION="Arbitrary precision float arithmetics and functions"
HOMEPAGE="https://crd-legacy.lbl.gov/~dhbailey/mpdist/"
SRC_URI="https://github.com/BL-highprecision/${PN^^}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${P^^}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_fma3 cpu_flags_x86_fma4 fortran qd"

DEPEND="qd? ( sci-libs/qd[fortran=] )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.19-ax_cxx_fma.patch #Bug 731912
	"${FILESDIR}"/${PN}-2.2.19-narrowing.patch #Bug 731916
	"${FILESDIR}"/${PN}-2.2.19-noregister.patch #Bug 926266
	"${FILESDIR}"/${P}-automake.patch
)

src_prepare() {
	default
	sed -e '/TESTS =/s/ io//' -i tests/Makefile.am || die # bug 526960

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable cpu_flags_x86_fma$(usex cpu_flags_x86_fma3 3 4) fma)
		$(use_enable fortran)
		$(use_enable qd)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	if use fortran; then
		emake toolkit
		cd toolkit || die
		./mathinit || die "mathinit failed"
	fi
}

src_install() {
	default

	if use fortran; then
		cd toolkit || die

		exeinto /usr/libexec/${PN}
		doexe mathtool

		insinto /usr/libexec/${PN}
		doins *.dat

		cat > mathtool.exe <<- _EOF_ || die
			#!/usr/bin/env sh
			cd "${EPREFIX}/usr/libexec/${PN}" && exec ./mathtool
		_EOF_

		newbin mathtool.exe mathtool
		newdoc README README.mathtool
	fi
	rm -r "${D}"/usr/share/doc/${PN} || die
}
