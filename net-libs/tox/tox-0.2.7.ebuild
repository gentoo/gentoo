# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils systemd user

MY_P="c-toxcore-${PV}"
DESCRIPTION="Encrypted P2P, messaging, and audio/video calling platform"
HOMEPAGE="https://tox.chat"
SRC_URI="https://github.com/TokTok/c-toxcore/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0/0.2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+av daemon ipv6 log-debug log-trace +no-log static-libs test"

REQUIRED_USE="^^ ( no-log log-trace log-debug )"

RDEPEND="
	av? ( media-libs/libvpx:=
		media-libs/opus )
	daemon? ( dev-libs/libconfig )
	>=dev-libs/libsodium-0.6.1:=[asm,urandom]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cmake-utils_src_prepare
	# disable tests that need internet
	for testname in bootstrap lan_discovery tcp_relay tox_many_tcp; do
		sed -i -e "/^auto_test(${testname})$/d" CMakeLists.txt || die
	done
}

src_configure() {
	local mycmakeargs=(
		-DTRACE=$(usex log-trace)
		-DDEBUG=$(usex log-debug)
		-DBUILD_TOXAV=$(usex av)
		-DMUST_BUILD_TOXAV=$(usex av)
		-DBOOTSTRAP_DAEMON=$(usex daemon)
		-DENABLE_STATIC=$(usex static-libs)
		-DENABLE_SHARED=ON
	)
	if use test; then
		mycmakeargs+=(-DBUILD_AV_TEST=ON)
		if use ipv6; then
			mycmakeargs+=(-DUSE_IPV6=ON)
		fi
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

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
		enewgroup tox
		enewuser tox -1 -1 -1 tox
		if [[ -f ${EROOT%/}/var/lib/tox-dht-bootstrap/key ]]; then
			ewarn "Backwards compatability with the bootstrap daemon might have been"
			ewarn "broken a while ago. To resolve this issue, REMOVE the following files:"
			ewarn "    ${EROOT%/}/var/lib/tox-dht-bootstrap/key"
			ewarn "    ${EROOT%/}/etc/tox-bootstrapd.conf"
			ewarn "    ${EROOT%/}/run/tox-dht-bootstrap/tox-dht-bootstrap.pid"
			ewarn "Then just re-emerge net-libs/tox"
		fi
	fi
}
