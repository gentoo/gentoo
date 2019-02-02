# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools flag-o-matic java-pkg-opt-2 python-single-r1

DESCRIPTION="General-purpose cryptography library"
HOMEPAGE="https://sourceforge.net/projects/beecrypt/"
SRC_URI="mirror://sourceforge/beecrypt/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ~ia64 ppc ppc64 ~s390 ~sh sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="+threads java cxx python static-libs doc"
REQUIRED_USE="cxx? ( threads )
	python? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="!<app-arch/rpm-4.2.1
	cxx? ( >=dev-libs/icu-6.1:= )
	python? ( ${PYTHON_DEPS} )"

DEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jdk-1.4 )
	doc? ( app-doc/doxygen
		virtual/latex-base
		dev-texlive/texlive-fontsextra
	)"
RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.4 )"

DOCS=( BUGS README BENCHMARKS NEWS )
PATCHES=(
	"${FILESDIR}"/${P}-build-system.patch
	"${FILESDIR}"/${P}-gcc-4.7.patch

	# Fixes bug 596904
	"${FILESDIR}"/${P}-c++11-allow-throw-in-destructors.patch
	"${FILESDIR}"/${P}-cast-uchar.patch #618676

	"${FILESDIR}"/${P}-icu-61.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# ICU needs char16_t support now
	# bug 649548
	append-cxxflags -std=c++14

	# Crudely disable amd64 assembly code
	# as it assumes 64-bit 'unsinged long' size. bug #461960
	local x32_hack=()
	use amd64 && [[ ${ABI} == "x32" ]] && x32_hack=(--enable-debug)

	# cplusplus needs threads support
	ac_cv_java_include=$(use java && java-pkg_get-jni-cflags) \
	econf \
		--disable-expert-mode \
		$(use_enable static-libs static) \
		$(use_enable threads) \
		$(use_with python python "${PYTHON}") \
		$(use_with cxx cplusplus) \
		$(use_with java) \
		"${x32_hack[@]}"
}

src_compile() {
	default

	if use doc; then
		pushd include/beecrypt >/dev/null || die
		doxygen || die "doxygen failed"
		popd >/dev/null || die
		HTML_DOCS=( docs/html/*.{css,html,js,png} )
	fi
}

src_test() {
	export BEECRYPT_CONF_FILE="${T}/beecrypt-test.conf"
	echo "provider.1=${S}/c++/provider/.libs/base.so" > "${BEECRYPT_CONF_FILE}" || die
	emake check bench
}

src_install() {
	default

	if use python; then
		rm -f "${D%/}$(python_get_sitedir)"/_bc.*a || die
	fi
	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
