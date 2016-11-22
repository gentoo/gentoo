# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="noVNC is a VNC client implemented using HTML5 technologies"
HOMEPAGE="https://kanaka.github.com/noVNC/"
SRC_URI="https://github.com/kanaka/noVNC/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/noVNC-${PV}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/websockify[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"

python_compile() {
	echo
}

src_install() {
	dodir /usr/share/novnc/utils
	dodir /usr/share/novnc/include
	dodir /usr/share/novnc/images

	exeinto /usr/share/novnc/utils
	doexe utils/b64-to-binary.pl
	doexe utils/img2js.py
	doexe utils/inflator.partial.js
	doexe utils/json2graph.py
	doexe utils/launch.sh
	doexe utils/parse.js
	doexe utils/u2x11

	docinto /usr/share/novnc/docs
	dodoc README.md
	dodoc LICENSE.txt

	cp -pPR *.html "${D}/usr/share/novnc/"
	cp -pPR include/* "${D}/usr/share/novnc/include/"
	cp -pPR images/* "${D}/usr/share/novnc/images/"
	dosym /usr/share/novnc/images/favicon.ico /usr/share/novnc/

	newconfd "${FILESDIR}/noVNC.confd" noVNC
	newinitd "${FILESDIR}/noVNC.initd" noVNC
}
