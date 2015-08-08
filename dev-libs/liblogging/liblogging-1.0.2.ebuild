# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils eutils

DESCRIPTION="Liblogging is an easy to use, portable, open source library for system logging"
HOMEPAGE="http://www.liblogging.org"
SRC_URI="https://github.com/rsyslog/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/0"
KEYWORDS="~amd64 ~arm ~hppa ~x86"
IUSE="rfc3195 static-libs +stdlog systemd"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/docutils
	virtual/pkgconfig
"

DOCS=( ChangeLog )

src_prepare() {
	sed -i -e 's|rst2man|rst2man.py|g' configure.ac || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable rfc3195)
		$(use_enable stdlog)
		$(use_enable systemd journal)
	)
	autotools-utils_src_configure
}
