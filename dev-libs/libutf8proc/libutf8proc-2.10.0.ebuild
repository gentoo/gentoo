# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit toolchain-funcs

EAW="${PN}-EastAsianWidth-16.0.0"

DESCRIPTION="A clean C Library for processing UTF-8 Unicode data"
HOMEPAGE="https://github.com/JuliaStrings/utf8proc"
SRC_URI="https://github.com/JuliaStrings/${PN#lib}/archive/v${PV}/${P#lib}.tar.gz -> ${P}.tar.gz
	cjk? ( https://dev.gentoo.org/~hattya/distfiles/${EAW}.xz )"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="cjk static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( =app-i18n/unicode-data-16.0* )"
S="${WORKDIR}/${P#lib}"

QA_PKGCONFIG_VERSION="3.1.0"

src_prepare() {
	if use cjk; then
		einfo "Modifying East Asian Ambiguous (A) as wide ..."
		cp "${WORKDIR}"/${EAW} ${PN#lib}_data.c || die

		sed -i \
			-e "/return .*_CATEGORY_CO/s/ ||.*/;/" \
			-e "/if (ambiguous/,/}/d" \
			-e "/0xe000/d" \
			test/charwidth.c
	fi

	sed -i "/^libdir/s:/lib:/$(get_libdir):" Makefile
	default
}

src_compile() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		prefix="${EPREFIX}/usr"
}

src_test() {
	cp "${BROOT}"/usr/share/unicode-data/{DerivedCoreProperties,{Normalization,auxiliary/GraphemeBreak}Test}.txt data || die

	local name
	for name in Uppercase Lowercase; do
		sed -n "/# Derived Property: ${name}/,/# Total code points:/p" data/DerivedCoreProperties.txt >data/${name}.txt
	done

	emake CC="$(tc-getCC)" check
}

src_install() {
	emake \
		DESTDIR="${D}" \
		prefix="${EPREFIX}/usr" \
		install
	use static-libs || find "${ED}" -name '*.a' -delete || die
}
