# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3 systemd user

DESCRIPTION="Encrypted P2P, messaging, and audio/video calling platform"
HOMEPAGE="https://tox.chat"
SRC_URI=""
EGIT_REPO_URI="https://github.com/TokTok/c-toxcore.git"

LICENSE="GPL-3+"
SLOT="0/0.2"
KEYWORDS=""
IUSE="+av daemon log-debug log-trace +no-log static-libs test"

REQUIRED_USE="^^ ( no-log log-trace log-debug )"

RDEPEND="
	av? ( media-libs/libvpx:=
		media-libs/opus )
	daemon? ( dev-libs/libconfig )
	>=dev-libs/libsodium-0.6.1:=[asm,urandom,-minimal]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DTRACE=$(usex log-trace)
		-DDEBUG=$(usex log-debug)
		-DBUILD_TOXAV=$(usex av)
		-DMUST_BUILD_TOXAV=$(usex av)
		-DBUILD_AV_TEST=$(usex av)
		-DBOOTSTRAP_DAEMON=$(usex daemon)
		-DENABLE_STATIC=$(usex static-libs)
	)

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

	find "${D}" -name '*.la' -delete || die
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
