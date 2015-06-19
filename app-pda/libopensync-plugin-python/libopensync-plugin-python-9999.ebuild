# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/libopensync-plugin-python/libopensync-plugin-python-9999.ebuild,v 1.5 2012/05/03 20:21:00 jdhore Exp $

EAPI="3"
PYTHON_DEPEND="2:2.5"

inherit cmake-utils python subversion

DESCRIPTION="OpenSync Python Module"
HOMEPAGE="http://www.opensync.org/"
SRC_URI=""

ESVN_REPO_URI="http://svn.opensync.org/plugins/python-module"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="LGPL-2.1"
IUSE=""

RDEPEND="~app-pda/libopensync-${PV}
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	# hardcoded python versions, use the module shipped with cmake (bug #276220)
	rm "${S}"/cmake/modules/FindPythonLibs.cmake || die
}
