# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Libraries for standards-based RTP/RTCP/RTSP multimedia streaming"
HOMEPAGE="http://www.live555.com/"
# bug #719336
SRC_URI="
	http://www.live555.com/liveMedia/public/${P/-/.}.tar.gz
	https://download.videolan.org/contrib/live555/${P/-/.}.tar.gz
"
S="${WORKDIR}/live"

LICENSE="LGPL-2.1"
# follow versioning in config.linux-with-shared-libraries
# SLOT="0/${libliveMedia_VERSION_CURRENT}.${libBasicUsageEnvironment_VERSION_CURRENT}.${libUsageEnvironment_VERSION_CURRENT}.${libgroupsock_VERSION_CURRENT}"
SLOT="0/116.3.5.32"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE="ssl tools"

# no tests
RESTRICT="test"

DEPEND="ssl? ( dev-libs/openssl:= )"
RDEPEND="${DEPEND}"

src_configure() {
	# sanity check subslot to kick would be drive by bumpers
	local detected_abi
	detected_abi="$(awk -F'=' '$1 ~ ".*_VERSION_CURRENT" {printf("%s.",$2)}' config.linux-with-shared-libraries)"
	detected_abi="${detected_abi%.}"
	if [[ "${SLOT}" != "0/${detected_abi}" ]]; then
		die "SLOT ${SLOT} doesn't match upstream specified ABI ${detected_abi}."
	fi

	# This ebuild uses its own build system
	# We don't want to call ./configure or anything here.
	# The only thing we can do is honour the user's SSL preference.
	if ! use ssl ; then
		einfo "Disabling SSL support"
		append-cppflags -DNO_OPENSSL=1
		sed -i -e 's|-lssl -lcrypto||' config.linux-with-shared-libraries || die
	fi

	if ! use tools ; then
		einfo "Disabling tools"
		# Remove testprogs build+install
		# http://www.live555.com/liveMedia/#testProgs
		sed -i -e '/subdirs/ { s/testProgs// } ' genMakefiles || die
		sed -i -e '/TESTPROGS_DIR/d' Makefile.tail ||  die
	fi

	# Bug 718912
	tc-export CC CXX

	# ODR violations bug #940324
	filter-lto

	# BasicTaskScheduler.cpp:191:40: error: 'struct std::atomic_flag' has no member named 'test'
	append-cxxflags -std=c++20

	# And defer to the scripts that upstream provide.
	./genMakefiles linux-with-shared-libraries || die
}

src_install() {
	emake PREFIX="${ED}/usr" LIBDIR="${ED}/usr/$(get_libdir)" install

	einstalldocs
}
