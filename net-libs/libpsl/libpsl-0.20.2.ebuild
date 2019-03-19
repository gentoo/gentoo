# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="C library for the Public Suffix List"
HOMEPAGE="https://github.com/rockdaboot/libpsl"
SRC_URI="https://github.com/rockdaboot/${PN}/releases/download/${P}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="icu +idn +man"

REQUIRED_USE="^^ ( icu idn )"

RDEPEND="
	icu? ( dev-libs/icu:=[${MULTILIB_USEDEP}] )
	idn? (
		dev-libs/libunistring[${MULTILIB_USEDEP}]
		net-dns/libidn2:=[${MULTILIB_USEDEP}]
	)
"

DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/gtk-doc-am
	sys-devel/gettext
	virtual/pkgconfig
	man? ( dev-libs/libxslt )
"

multilib_src_configure() {
	local myeconfargs=(
		--disable-asan
		--disable-cfi
		--disable-ubsan
		$(use_enable man)
	)

	if use icu || use idn ; then
		if use icu ; then
			myeconfargs+=(
				--enable-builtin=libicu
				--enable-runtime=libicu
			)
		fi
		if use idn ; then
			myeconfargs+=(
				--enable-builtin=libidn2
				--enable-runtime=libidn2
			)
		fi
	else
		myeconfargs+=( --disable-runtime )
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	default

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
