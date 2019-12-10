# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Open-source implementation of the Secure Real-time Transport Protocol (SRTP)"
HOMEPAGE="https://github.com/cisco/libsrtp"
SRC_URI="https://github.com/cisco/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="alpha amd64 ~arm arm64 ~hppa ia64 ppc ppc64 -sparc x86 ~ppc-macos ~x64-macos ~x86-macos"
IUSE="aesicm console debug doc libressl openssl static-libs syslog test"
RESTRICT="!test? ( test )"

RDEPEND="
	openssl? (
		!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
	)
"
DEPEND="${RDEPEND}"

DOCS=( CHANGES README TODO )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/srtp/config.h
)
PATCHES=(
	"${FILESDIR}/${PN}-pcap-automagic-r0.patch"
	"${FILESDIR}/${P}-openssl-hmac.patch"
	"${FILESDIR}/${P}-openssl-aem_icm-key.patch"
	"${FILESDIR}/${P}-openssl-aem_gcm-key.patch"
	"${FILESDIR}/${P}-openssl-1.1.patch"
)

src_prepare() {
	default

	# test/rtpw.c is using /usr/share/dict/words assuming it exists
	# using test/rtpw.c guaratees the file exists in any case
	sed -i -e "s:/usr/share/dict/words:rtpw.c:" test/rtpw.c || die

	mv configure.in configure.ac || die
	eautoreconf
}

multilib_src_configure() {
	# stdout: default error output for messages in debug
	# kernel-linux: breaks the build
	# gdoi: disabled by upstream and breaks the build
	# pcap: seems to be test-only
	ECONF_SOURCE=${S} \
	econf \
		--enable-stdout \
		--disable-kernel-linux \
		--disable-gdoi \
		--disable-pcap \
		$(use_enable aesicm generic-aesicm) \
		$(use_enable console) \
		$(use_enable debug) \
		$(use_enable openssl) \
		$(use_enable syslog)
}

multilib_src_compile() {
	use static-libs && emake ${PN}.a
	emake shared_library
	use test && emake test
}

multilib_src_test() {
	# work-around tests that do not like out-of-source builds
	cp "${S}"/test/{getopt_s,rtpw}.c "${BUILD_DIR}"/test/ || die

	LD_LIBRARY_PATH="${BUILD_DIR}" emake -j1 runtest

	# Makefile.in has '$(testapp): libsrtp.a'
	if use !static-libs; then
		rm libsrtp.a || die
	fi
}

multilib_src_install_all() {
	# libsrtp.pdf can also be generated with doxygen
	# but it would be a waste of time as an up-to-date version is built
	use doc && DOCS+=( doc/*.txt doc/${PN}.pdf )
	einstalldocs
}
