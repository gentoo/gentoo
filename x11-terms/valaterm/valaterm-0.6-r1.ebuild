# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
VALA_MIN_API_VERSION="0.16"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils vala

DESCRIPTION="A lightweight vala based terminal"
HOMEPAGE="https://github.com/jpdeplaix/${PN}"
SRC_URI="${HOMEPAGE}archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

S="${WORKDIR}/${PN}-${PN}"

src_prepare() {
	# Temporary workaround for the fact that vala.eclass doesn't support
	# EAPI=6.
	eapply_user
	vala_src_prepare
}

src_configure() {
	# If you try --enable-nls, it barfs.
	local myconf=''
	use nls || myconf='--disable-nls'
	waf-utils_src_configure --custom-flags --verbose ${myconf}
}
