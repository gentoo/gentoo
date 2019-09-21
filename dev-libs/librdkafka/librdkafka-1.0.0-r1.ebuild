# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="Apache Kafka C/C++ client library"
HOMEPAGE="https://github.com/edenhill/librdkafka"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/edenhill/${PN}.git"

	inherit git-r3
else
	SRC_URI="https://github.com/edenhill/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~x86"
fi

LICENSE="BSD-2"

# subslot = soname version
SLOT="0/1"

IUSE="lz4 sasl ssl static-libs zstd"

RDEPEND="
	lz4? ( app-arch/lz4:=[static-libs(-)?] )
	sasl? ( dev-libs/cyrus-sasl:= )
	ssl? ( dev-libs/openssl:0= )
	zstd? ( app-arch/zstd:= )
	sys-libs/zlib
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${P}-remove-automagic-on-zstd.patch )

src_configure() {
	tc-export CC CXX LD NM OBJDUMP PKG_CONFIG STRIP

	local myeconf=(
		--no-cache
		--no-download
		--disable-debug-symbols
		$(use_enable lz4)
		$(use_enable sasl)
		$(usex static-libs '--enable-static' '')
		$(use_enable ssl)
		$(use_enable zstd)
	)

	econf ${myeconf[@]}
}

src_test() {
	emake -C tests run_local
}

src_install() {
	local DOCS=(
		README.md
		CONFIGURATION.md
		INTRODUCTION.md
	)

	default

	if ! use static-libs; then
		find "${ED}"/usr/lib* -name '*.la' -o -name '*.a' -delete || die
	fi
}
