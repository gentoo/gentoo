# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit multilib-minimal python-any-r1

DESCRIPTION="C library for the Public Suffix List"
HOMEPAGE="https://github.com/rockdaboot/libpsl"
SRC_URI="https://github.com/rockdaboot/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="icu +idn +man"

RDEPEND="
	icu? ( !idn? ( dev-libs/icu:=[${MULTILIB_USEDEP}] ) )
	idn? (
		dev-libs/libunistring:=[${MULTILIB_USEDEP}]
		net-dns/libidn2:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	dev-util/gtk-doc-am
	sys-devel/gettext
	virtual/pkgconfig
	man? ( dev-libs/libxslt )
"

pkg_pretend() {
	if use icu && use idn ; then
		ewarn "\"icu\" and \"idn\" USE flags are enabled."
		ewarn "Using \"idn\"."
	fi
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-asan
		--disable-cfi
		--disable-ubsan
		--disable-static
		$(use_enable man)
	)

	# Prefer idn even if icu is in USE as well
	if use idn ; then
		myeconfargs+=(
			--enable-builtin=libidn2
			--enable-runtime=libidn2
		)
	elif use icu ; then
		myeconfargs+=(
			--enable-builtin=libicu
			--enable-runtime=libicu
		)
	else
		myeconfargs+=( --disable-runtime )
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	default

	find "${ED}" -type f -name "*.la" -delete || die
}
