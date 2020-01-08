# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal

DESCRIPTION="Open-source implementation of the Secure Real-time Transport Protocol (SRTP)"
HOMEPAGE="https://github.com/cisco/libsrtp"
SRC_URI="https://github.com/cisco/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="2/1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 -sparc x86 ~ppc-macos ~x64-macos ~x86-macos"
IUSE="aesicm console debug doc libressl openssl static-libs syslog test"
RESTRICT="!test? ( test )"

RDEPEND="
	openssl? (
		!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
	)
"
DEPEND="${RDEPEND}"

DOCS=( CHANGES )

PATCHES=( "${FILESDIR}/${P}-pcap-automagic-r0.patch" )

src_prepare() {
	default

	# test/rtpw.c is using /usr/share/dict/words assuming it exists
	# using test/rtpw.c guaratees the file exists in any case
	sed -i -e "s:/usr/share/dict/words:rtpw.c:" test/rtpw.c || die

	eautoreconf

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
		$(use_enable openssl)
}

multilib_src_compile() {
	use static-libs && emake ${PN}2.a
	emake shared_library
	use test && emake test
}

multilib_src_test() {
	LD_LIBRARY_PATH="${BUILD_DIR}" emake -j1 runtest

	# Makefile.in has '$(testapp): libsrtp2.a'
	if use !static-libs; then
		rm libsrtp2.a || die
	fi
}

multilib_src_install_all() {
	# libsrtp.pdf can be generated with doxygen, but it seems to be broken.
	use doc && DOCS+=( doc/*.txt )
	einstalldocs
}
