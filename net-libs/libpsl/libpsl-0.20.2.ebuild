# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C library for the Public Suffix List"
HOMEPAGE="https://github.com/rockdaboot/libpsl"
SRC_URI="https://github.com/rockdaboot/${PN}/releases/download/${P}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="icu +idn +man"

REQUIRED_USE="^^ ( icu idn )"

RDEPEND="
	icu? ( dev-libs/icu:= )
	idn? (
		dev-libs/libunistring
		net-dns/libidn2:=
	)
"

DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/gtk-doc
	sys-devel/gettext
	virtual/pkgconfig
	man? ( dev-libs/libxslt )
"

src_configure() {
	local myeconfargs=(
		--enable-ubsan
		--disable-asan
		--disable-cfi
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

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
