# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd

DESCRIPTION="Encrypted P2P, messaging, and audio/video calling platform"
HOMEPAGE="https://tox.chat https://github.com/TokTok/c-toxcore"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TokTok/c-toxcore.git"
else
	MY_P="c-toxcore-${PV}"
	SRC_URI="https://github.com/TokTok/c-toxcore/releases/download/v${PV}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-3+"
SLOT="0/0.2"
IUSE="+av debug daemon dht-node experimental ipv6 key-utils log-debug +log-error log-info log-trace log-warn test"

REQUIRED_USE="?? ( log-debug log-error log-info log-trace log-warn )
		daemon? ( dht-node )"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"
DEPEND="dev-libs/libsodium:=[asm,urandom,-minimal(-)]
	av? (
		media-libs/libvpx:=
		media-libs/opus
	)
	daemon? ( dev-libs/libconfig:= )"

RDEPEND="${DEPEND}
	daemon? (
		acct-group/tox
		acct-user/tox
	)
	key-utils? ( || ( sys-devel/gcc[openmp] llvm-core/clang-runtime[openmp] ) )"

src_prepare() {
	cmake_src_prepare

	#Remove faulty tests
	for testname in lan_discovery; do
		sed -i -e "/^auto_test(${testname})$/d" ./auto_tests/CMakeLists.txt || die
	done
}

src_configure() {
	local mycmakeargs=(
		-DAUTOTEST=$(usex test ON OFF)
		-DBOOTSTRAP_DAEMON=$(usex daemon ON OFF)
		-DBUILD_FUN_UTILS=$(usex key-utils ON OFF)
		-DBUILD_FUZZ_TESTS=OFF #Requires the compiler to be Clang
		-DBUILD_MISC_TESTS=$(usex test ON OFF)
		-DBUILD_TOXAV=$(usex av ON OFF)
		-DCMAKE_BUILD_TYPE=$(usex debug Debug Release)
		-DDHT_BOOTSTRAP=$(usex dht-node ON OFF)
		-DENABLE_SHARED=ON
		-DENABLE_STATIC=OFF
		-DEXPERIMENTAL_API=$(usex experimental ON OFF)
		-DFULLY_STATIC=OFF
		-DMUST_BUILD_TOXAV=$(usex av ON OFF)
		-DUNITTEST=OFF
	)

	if use test; then
		mycmakeargs+=(
			-DNON_HERMETIC_TESTS=OFF
			-DPROXY_TEST=OFF
			-DTEST_TIMEOUT_SECONDS=150
			-DUSE_IPV6=$(usex ipv6 ON OFF)
		)
	else
		mycmakeargs+=(-DUSE_IPV6=OFF)
	fi

	if use log-trace; then
		mycmakeargs+=(-DMIN_LOGGER_LEVEL="TRACE")
	elif use log-debug; then
		mycmakeargs+=(-DMIN_LOGGER_LEVEL="DEBUG")
	elif use log-info; then
		mycmakeargs+=(-DMIN_LOGGER_LEVEL="INFO")
	elif use log-warn; then
		mycmakeargs+=(-DMIN_LOGGER_LEVEL="WARNING")
	elif use log-error; then
		mycmakeargs+=(-DMIN_LOGGER_LEVEL="ERROR")
	else
		mycmakeargs+=(-DMIN_LOGGER_LEVEL="")
		einfo "Logging disabled"
	fi

	cmake_src_configure
}

src_test() {
	cmake_src_test -j1
}

src_install() {
	cmake_src_install

	if use daemon; then
		newinitd "${FILESDIR}"/initd tox-dht-daemon
		newconfd "${FILESDIR}"/confd tox-dht-daemon
		insinto /etc
		doins "${FILESDIR}"/tox-bootstrapd.conf
		systemd_dounit "${FILESDIR}"/tox-bootstrapd.service
	fi
}
