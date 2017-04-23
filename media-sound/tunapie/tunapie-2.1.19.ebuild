# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1

DESCRIPTION="Directory browser for Radio and TV streams"
HOMEPAGE="http://tunapie.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="offensive"

RDEPEND=">=dev-python/wxpython-2.6[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	default

	# fix pixmap lookup
	sed -i -e 's@../pixmaps@../../share/pixmaps@' \
		src/tunapie2_main.py || die

	# the original script requires more sed than code,
	cat > tunapie <<-_EOF_ || die
		#!/bin/sh
		exec ${EPYTHON} /usr/lib/tunapie/Tunapie.py
	_EOF_
}

src_install() {
	dobin tunapie
	doman tunapie.1
	dodoc CHANGELOG README

	python_moduleinto /usr/lib/tunapie
	python_domodule src/{*.py,*.png}

	doicon src/tplogo.xpm
	domenu tunapie.desktop

	dodir /etc
	usex offensive 1 0 > "${ED%/}"/etc/tunapie.config || die
}
