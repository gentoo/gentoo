# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1

inherit autotools distutils-r1

DESCRIPTION="Lightweight, robust, and efficient POSIX compliant regexp matching library"
HOMEPAGE="
	https://laurikari.net/tre/
	https://github.com/laurikari/tre
"
# missing files in dist bug #949527
# https://github.com/laurikari/tre/pull/118
SRC_URI="
	https://github.com/laurikari/tre/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~arm64-macos ~x64-macos"
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
	"${FILESDIR}/${PN}-tests.patch"
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
