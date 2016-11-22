# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils user systemd

DESCRIPTION="Encrypted P2P, messaging, and audio/video calling platform"
HOMEPAGE="https://tox.chat"
EGIT_COMMIT="94cc8b11ff473064526737936f64b6f9a19c239d"
SRC_URI="https://github.com/irungentoo/toxcore/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+av daemon log-debug log-error log-info log-trace log-warn +no-log ntox static-libs test"

REQUIRED_USE="^^ ( no-log log-trace log-debug log-info log-warn log-error )"

RDEPEND="
	av? ( media-libs/libvpx
		media-libs/opus )
	daemon? ( dev-libs/libconfig )
	ntox? ( sys-libs/ncurses )
	>=dev-libs/libsodium-0.6.1[asm,urandom]"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )
	virtual/pkgconfig"

S="${WORKDIR}/toxcore-${EGIT_COMMIT}"

src_prepare() {
	epatch_user
	eautoreconf
}

src_configure() {
	econf \
		$(usex log-trace "--enable-logging --with-log-level=TRACE" "") \
		$(usex log-debug "--enable-logging --with-log-level=DEBUG" "") \
		$(usex log-info "--enable-logging --with-log-level=INFO" "") \
		$(usex log-warn "--enable-logging --with-log-level=WARNING" "") \
		$(usex log-error "--enable-logging --with-log-level=ERROR" "") \
		$(use_enable av) \
		$(use_enable test tests) \
		$(use_enable ntox) \
		$(use_enable daemon) \
		$(use_enable static-libs static)
}

src_install() {
	default
	if use daemon; then
		newinitd "${FILESDIR}"/initd tox-dht-daemon
		newconfd "${FILESDIR}"/confd tox-dht-daemon
		insinto /etc
		doins "${FILESDIR}"/tox-bootstrapd.conf
		systemd_dounit "${FILESDIR}"/tox-bootstrapd.service
	fi

	prune_libtool_files
}

pkg_postinst() {
	if use daemon; then
		enewgroup ${PN}
		enewuser ${PN} -1 -1 -1 ${PN}
		if [[ -f ${EROOT}var/lib/tox-dht-bootstrap/key ]]; then
			ewarn "Backwards compatability with the bootstrap daemon might have been"
			ewarn "broken a while ago. To resolve this issue, REMOVE the following files:"
			ewarn "    /var/lib/tox-dht-bootstrap/key"
			ewarn "    /etc/tox-bootstrapd.conf"
			ewarn "    /run/tox-dht-bootstrap/tox-dht-bootstrap.pid"
			ewarn "Then just re-emerge net-libs/tox"
		fi
	fi
}
