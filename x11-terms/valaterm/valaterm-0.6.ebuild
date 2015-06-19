# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/valaterm/valaterm-0.6.ebuild,v 1.5 2015/01/03 13:49:42 mgorny Exp $

EAPI=4
VALA_MIN_API_VERSION="0.16"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils vala

DESCRIPTION="A lightweight vala based terminal"
HOMEPAGE="http://gitorious.org/valaterm"
SRC_URI="http://gitorious.org/${PN}/${PN}/archive-tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND=">=dev-libs/glib-2
	x11-libs/gtk+:3
	x11-libs/vte:2.90"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
		)"

DOCS="AUTHORS ChangeLog README TODO"

S=${WORKDIR}/${PN}-${PN}

src_configure() {
	local myconf
	use nls || myconf='--disable-nls'
	waf-utils_src_configure --custom-flags --verbose ${myconf}
}
