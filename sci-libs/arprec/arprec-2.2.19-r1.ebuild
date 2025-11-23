# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=fortran
FORTRAN_STANDARD=90

inherit autotools fortran-2

DESCRIPTION="Arbitrary precision float arithmetics and functions"
HOMEPAGE="https://crd-legacy.lbl.gov/~dhbailey/mpdist/"
SRC_URI="https://crd.lbl.gov/~dhbailey/mpdist/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_fma3 cpu_flags_x86_fma4 doc fortran qd static-libs"

DEPEND="qd? ( sci-libs/qd[fortran=] )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gold.patch
)

src_prepare() {
	default
	sed -e '/TESTS =/s/ io//' -i tests/Makefile.am || die # bug 526960

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable static-libs static)
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

		exeinto /usr/libexec/${PN}/.libs
		doexe .libs/mathtool

		insinto /usr/libexec/${PN}
		doins *.dat

		cat > mathtool.exe <<- _EOF_ || die
			#!/usr/bin/env sh
			cd "${EPREFIX}/usr/libexec/${PN}" && exec ./mathtool
		_EOF_

		newbin mathtool.exe mathtool
		newdoc README README.mathtool
	fi

	if ! use doc; then
		rm "${ED}"/usr/share/doc/${PF}/*.pdf || die
	fi

	if ! use static-libs; then
		find "${D}" -type f -name '*.la' -delete || die
	fi
}
