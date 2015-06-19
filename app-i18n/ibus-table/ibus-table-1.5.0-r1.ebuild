# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-table/ibus-table-1.5.0-r1.ebuild,v 1.1 2014/12/27 11:24:29 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"
inherit eutils python-single-r1

DESCRIPTION="The Table Engine for IBus Framework"
HOMEPAGE="http://code.google.com/p/ibus/"
SRC_URI="http://ibus.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="${PYTHON_DEPS}
	>=app-i18n/ibus-1.2[python,${PYTHON_USEDEP}]
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.16.1 )
	virtual/pkgconfig"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

src_prepare() {
	python_fix_shebang .

	sed -i -e "s/python/${EPYTHON}/" \
		engine/ibus-table-createdb.in engine/ibus-engine-table.in || die
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog NEWS README
}
