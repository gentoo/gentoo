# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3 systemd

DESCRIPTION="Encrypted P2P, messaging, and audio/video calling platform"
HOMEPAGE="https://tox.chat"
SRC_URI=""
EGIT_REPO_URI="https://github.com/TokTok/c-toxcore.git"

LICENSE="GPL-3+"
SLOT="0/0.2"
KEYWORDS=""
IUSE="+av daemon dht-node ipv6 log-debug +log-error log-info log-trace log-warn static-libs test"
RESTRICT="!test? ( test )"

REQUIRED_USE="^^ ( log-debug log-error log-info log-trace log-warn )
		daemon? ( dht-node )"

BDEPEND="virtual/pkgconfig"
DEPEND=">dev-libs/libsodium-0.6.1:=[asm,urandom,-minimal]
	av? (
		media-libs/libvpx:=
		media-libs/opus
	)
	daemon? ( dev-libs/libconfig:= )"
RDEPEND="
	${DEPEND}
	daemon? (
		acct-group/tox
		acct-user/tox
	)"

src_prepare() {
	cmake_src_prepare

	# Remove faulty tests
	local faultytest=(lan_discovery save_compatibility)
	local testname=
	for testname in "${faultytest[@]}"; do
		sed -i -e "/^auto_test(${testname})$/d" CMakeLists.txt || die
	done
}

src_configure() {
	local mycmakeargs=(
		-DAUTOTEST=$(usex test)
		-DBOOTSTRAP_DAEMON=$(usex daemon)
		-DBUILD_MISC_TESTS=$(usex test)
		-DBUILD_TOXAV=$(usex av)
		-DDHT_BOOTSTRAP=$(usex dht-node)
		-DENABLE_SHARED=ON
		-DENABLE_STATIC=$(usex static-libs)
		-DMUST_BUILD_TOXAV=$(usex av)
	)

	if use test; then
		mycmakeargs+=(
			-DTEST_TIMEOUT_SECONDS=120
			-DUSE_IPV6=$(usex ipv6)
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
		einfo "Logging Disabled"
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

pkg_postinst() {
	if use dht-node; then
		ewarn "There is currently an unresolved issuer with tox DHT"
		ewarn "Bootstrap node that causes the program to be built"
		ewarn "with a null libray reference. This causes an infinite"
		ewarn "loop for certain revdep-rebuild commands. If you aren't"
		ewarn "running a node, please consider disabling the dht node"
		ewarn "use flag. For more information please refer to"
		ewarn "https://github.com/toktok/c-toxcore/issues/1144"
	fi
}
