# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/novnc/novnc-0.4.ebuild,v 1.8 2015/04/18 12:22:34 swegener Exp $

EAPI=5

DESCRIPTION="noVNC is a VNC client implemented using HTML5 technologies"
HOMEPAGE="http://kanaka.github.com/noVNC/"
SRC_URI="https://github.com/kanaka/noVNC/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/noVNC-${PV}"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nova"

DEPEND=""
RDEPEND="${DEPEND}
		nova? ( dev-python/websockify
				sys-cluster/nova
				dev-python/matplotlib
				dev-python/numpy )"

src_install() {
	dodir /usr/share/novnc
	insinto /usr/share/novnc
	doins -r *.html images include
	dodoc README.md

	if use nova; then
		dobin utils/nova-novncproxy

		newconfd "${FILESDIR}/noVNC.confd" nova-noVNC
		newinitd "${FILESDIR}/noVNC.initd" nova-noVNC

		diropts -m 0750
		dodir /var/log/noVNC
	fi
}
