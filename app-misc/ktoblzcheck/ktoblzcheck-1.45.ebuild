# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ktoblzcheck/ktoblzcheck-1.45.ebuild,v 1.2 2014/12/27 15:50:20 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1

DESCRIPTION="Library to check account numbers and bank codes of German banks"
HOMEPAGE="http://ktoblzcheck.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="python"

RDEPEND="app-text/recode
	virtual/awk
	sys-apps/grep
	sys-apps/sed
	|| ( net-misc/wget www-client/lynx )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.2.6b"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	econf $(use_enable python)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
