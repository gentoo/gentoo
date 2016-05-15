# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

RESTRICT="test"

DESCRIPTION="Modular and portable cryptographic toolkit"
HOMEPAGE="http://www.libtom.org/"

SRC_URI="https://github.com/libtom/libtomcrypt/releases/download/${PV}/crypt-${PV}.tar.bz2"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	# avoid PDF regen
	emake NODOCS=1 DESTDIR="${D}" install
	cp doc/crypt.pdf "${D}/usr/share/doc/libtomcrypt/pdf"
}
