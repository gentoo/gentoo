# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="The Hangul engine for IBus input platform"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://github.com/choehwanjin/ibus-hangul/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
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
