# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
COMMIT="6092368aabdd0dbb0fbceb2766a37b98e0ff6911"
PYTHON_COMPAT=( python3_{10..12} pypy3 )
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1

inherit autotools distutils-r1

DESCRIPTION="Lightweight, robust, and efficient POSIX compliant regexp matching library"
HOMEPAGE="
	https://laurikari.net/tre/
	https://github.com/laurikari/tre
"
SRC_URI="https://github.com/laurikari/tre/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
IUSE="+agrep +alloca +approx debug nls profile python"

RDEPEND="
	agrep? (
		!dev-ruby/amatch
	)
	python?	( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"
BDEPEND="
	python? ( ${DISTUTILS_DEPS} )
	sys-devel/gettext
	virtual/pkgconfig"

REQUIRED_USE="
	agrep? ( approx )
	python? ( ${PYTHON_REQUIRED_USE} )
"

PATCHES=(
	"${FILESDIR}/0.8.0-pkgcfg.patch"
	"${FILESDIR}/0.8.0-CVE-2016-8559.patch"
	"${FILESDIR}/${PN}-chicken.patch"
	"${FILESDIR}/${PN}-issue37.patch"
	"${FILESDIR}/${PN}-issue50.patch"
	"${FILESDIR}/${PN}-issue55-part1.patch"
	"${FILESDIR}/${PN}-issue55-part2.patch"
	"${FILESDIR}/${PN}-python3.patch"
	"${FILESDIR}/${PN}-tests.patch"
	"${FILESDIR}/${PN}-c99.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--disable-static
		--disable-system-abi
		--enable-multibyte
		--enable-wchar
		$(use_enable agrep)
		$(use_enable approx)
		$(use_enable debug)
		$(use_enable nls)
		$(use_enable profile)
		$(use_with alloca)
	)
	econf "${myconf[@]}"
}

src_test() {
	if locale -a | grep -iq en_US.iso88591; then
		emake -j1 check
	else
		ewarn "If you like to run the test,"
		ewarn "please make sure en_US.ISO-8859-1 is installed."
		die "en_US.ISO-8859-1 locale is missing"
	fi
}

src_compile() {
	default

	if use python; then
		cd python || die
		distutils-r1_src_compile
	fi
}

src_install() {
	local HTML_DOCS=( doc/*.{css,html} )

	default

	use python && distutils-r1_src_install

	find "${ED}" -type f -name '*.la' -delete || die
}
