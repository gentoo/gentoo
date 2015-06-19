# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ktoblzcheck/ktoblzcheck-1.39.ebuild,v 1.5 2013/02/28 16:16:22 ottxor Exp $

EAPI=4
PYTHON_DEPEND="python? 2:2.6"
inherit python

DESCRIPTION="Library to check account numbers and bank codes of German banks"
HOMEPAGE="http://ktoblzcheck.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 ~sparc x86"
IUSE="python"

RDEPEND="app-text/recode
	virtual/awk
	sys-apps/grep
	sys-apps/sed
	|| ( net-misc/wget www-client/lynx )"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.2.6b"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	>py-compile
}

src_configure() {
	econf $(use_enable python)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}

pkg_postinst() {
	use python && python_mod_optimize ktoblzcheck.py
}

pkg_postrm() {
	use python && python_mod_cleanup ktoblzcheck.py
}
