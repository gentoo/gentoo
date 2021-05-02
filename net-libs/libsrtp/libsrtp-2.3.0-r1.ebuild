# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Open-source implementation of the Secure Real-time Transport Protocol (SRTP)"
HOMEPAGE="https://github.com/cisco/libsrtp"
SRC_URI="https://github.com/cisco/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="2/1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 -sparc x86 ~ppc-macos ~x64-macos"
IUSE="debug doc nss openssl static-libs test"
RESTRICT="!test? ( test )"

REQUIRED_USE="?? ( nss openssl )"

RDEPEND="
	openssl? (
		dev-libs/openssl:0=[${MULTILIB_USEDEP}]
	)
	nss? ( >=dev-libs/nss-3.52[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

BDEPEND="
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
"

DOCS=( CHANGES )

PATCHES=(
	"${FILESDIR}/${P}-gcc-10.patch"
	"${FILESDIR}/${P}-nss.patch"
	"${FILESDIR}/${P}-rtp-header.patch"
)

src_prepare() {
	default

	# autoconf-2.7x fix
	touch ar-lib || die

	eautoreconf

	if use doc; then
		echo "${PV}" > "${S}/VERSION"
	fi

	# sadly, tests are too broken to even consider using work-arounds
	multilib_copy_sources
}

multilib_src_configure() {
	# stdout: default error output for messages in debug
	# pcap: seems to be test-only
	# openssl-kdf: OpenSSL 1.1.0+
	econf \
		--enable-log-stdout \
		--disable-pcap \
		--disable-openssl-kdf \
		$(use_enable debug debug-logging) \
		$(use_enable openssl) \
		$(use_enable nss)
}

multilib_src_compile() {
	use static-libs && emake ${PN}2.a
	emake shared_library
	use test && emake test
	if multilib_is_native_abi && use doc; then
		emake libsrtp2doc
	fi
}

multilib_src_test() {
	LD_LIBRARY_PATH="${BUILD_DIR}" emake -j1 runtest

	# Makefile.in has '$(testapp): libsrtp2.a'
	if ! use static-libs; then
		rm libsrtp2.a || die
	fi
}

multilib_src_install() {
	default

	if multilib_is_native_abi && use doc; then
		dodoc -r doc/html
	fi
}

multilib_src_install_all() {
	einstalldocs
}
