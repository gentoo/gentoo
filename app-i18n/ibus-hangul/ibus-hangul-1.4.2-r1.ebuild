# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-hangul/ibus-hangul-1.4.2-r1.ebuild,v 1.1 2014/12/27 10:40:45 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="The Hangul engine for IBus input platform"
HOMEPAGE="http://code.google.com/p/ibus/"
SRC_URI="http://ibus.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=app-i18n/ibus-1.4[python,${PYTHON_USEDEP}]
	=dev-python/pygobject-2*[${PYTHON_USEDEP}]
	=dev-python/pygtk-2*[${PYTHON_USEDEP}]
	>=app-i18n/libhangul-0.1
	nls? ( virtual/libintl )
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		>=sys-devel/gettext-0.17
		)"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	sed -ie "s:python:${EPYTHON}:" \
		setup/ibus-setup-hangul.in || die
}

src_configure() {
	econf $(use_enable nls)
}
