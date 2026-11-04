# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd

# The notice is triggered by a docker file, which is unused here.
# https://bugs.gentoo.org/964599
CMAKE_QA_COMPAT_SKIP=1
CMP_COMMIT="52bfcfa17d2eb4322da2037ad625f5575129cece"

DESCRIPTION="Encrypted P2P, messaging, and audio/video calling platform"
HOMEPAGE="https://tox.chat https://github.com/TokTok/c-toxcore"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TokTok/c-toxcore.git"
	EGIT_SUBMODULES=( third_party/cmp )
else
	MY_P="c-toxcore-${PV}"
	SRC_URI="
		https://github.com/TokTok/c-toxcore/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz
		https://github.com/TokTok/cmp/archive/${CMP_COMMIT}.tar.gz -> toktok-cmp-${CMP_COMMIT}.tar.gz
	"
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
	key-utils? ( || ( sys-devel/gcc[openmp] llvm-runtimes/clang-runtime[openmp] ) )"

# Skip flaky tests.
CMAKE_SKIP_TESTS=(
	scenario_group_topic
	scenario_lan_discovery
	scenario_tox_many
)

src_unpack() {
	default

	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		rm -d ${MY_P}/third_party/cmp || die
		mv cmp-${CMP_COMMIT} ${MY_P}/third_party/cmp || die
	fi
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
	# Some tests appear to get flaky with multiple jobs running.
	# https://bugs.gentoo.org/730434
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

pkg_postinst() {
	if use daemon; then
		elog "Before you can run the daemon, you need to add nodes to"
		elog "configuration which exists at /etc/tox-bootstrapd.conf"
		elog "Details about these nodes can be found at https://nodes.tox.chat"
		elog "Then run, if necessary, #rc-update add tox-dht-daemon default"
	fi
}
