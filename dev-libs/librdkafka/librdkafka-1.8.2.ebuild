# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{9..11} )

inherit python-any-r1 toolchain-funcs

DESCRIPTION="Apache Kafka C/C++ client library"
HOMEPAGE="https://github.com/confluentinc/librdkafka"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/confluentinc/${PN}.git"

	inherit git-r3
else
	SRC_URI="https://github.com/confluentinc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
fi

LICENSE="BSD-2"

# subslot = soname version
SLOT="0/1"

IUSE="lz4 sasl ssl static-libs zstd"

LIB_DEPEND="
	lz4? ( app-arch/lz4:=[static-libs(+)] )
	sasl? ( dev-libs/cyrus-sasl:=[static-libs(+)] )
	ssl? ( dev-libs/openssl:0=[static-libs(+)] )
	zstd? ( app-arch/zstd:=[static-libs(+)] )
	sys-libs/zlib:=[static-libs(+)]
"

BDEPEND="
	virtual/pkgconfig
	${PYTHON_DEPS}
"

RDEPEND="!static-libs? ( ${LIB_DEPEND//\[static-libs(+)]} )"

DEPEND="
	${RDEPEND}
	static-libs? ( ${LIB_DEPEND} )
"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	default

	if [[ ${PV} != "9999" ]]; then
		sed -i \
			-e "s/^\(export RDKAFKA_GITVER=\).*/\1\"${PV}@release\"/" \
			tests/run-test.sh || die
	fi
}

src_configure() {
	tc-export AR CC CXX LD NM OBJDUMP PKG_CONFIG STRIP

	local myeconf=(
		--prefix="${EPREFIX}/usr"
		--build="${CBUILD}"
		--host="${CHOST}"
		--mandir="${EPREFIX}/usr/share/man"
		--infodir="${EPREFIX}/usr/share/info"
		--datadir="${EPREFIX}/usr/share"
		--sysconfdir="${EPREFIX}/etc"
		--localstatedir="${EPREFIX}/var"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--no-cache
		--no-download
		--disable-debug-symbols
		$(use_enable lz4)
		$(use_enable sasl)
		$(usex static-libs '--enable-static' '')
		$(use_enable ssl)
		$(use_enable zstd)
	)

	./configure ${myeconf[@]} || die
}

src_test() {
	# Simulate CI so we do not fail when tests are running longer than expected,
	# https://github.com/confluentinc/librdkafka/blob/v1.6.1/tests/0062-stats_event.c#L101-L116
	local -x CI=true

	emake -C tests run_local
}

src_install() {
	emake -j1 \
		DESTDIR="${D}" \
		docdir="/usr/share/doc/${PF}" \
		install

	if ! use static-libs; then
		find "${ED}" -type f \( -name "*.a" -o -name "*.la" \) -delete || die
	fi
}
