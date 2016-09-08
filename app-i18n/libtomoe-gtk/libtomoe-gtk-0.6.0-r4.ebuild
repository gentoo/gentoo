# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

MY_P="tomoe-gtk-${PV}"
DESCRIPTION="Tomoe GTK+ interface widget library"
HOMEPAGE="http://tomoe.sourceforge.jp/"
SRC_URI="mirror://sourceforge/tomoe/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=app-i18n/tomoe-0.6.0
	python? (
		${PYTHON_DEPS}
		>=app-i18n/tomoe-0.6.0[python,${PYTHON_USEDEP}]
		dev-python/pygtk:2[${PYTHON_USEDEP}]
		dev-python/pygobject:2[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
	sys-devel/gettext
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use python ; then
		python-single-r1_pkg_setup
	fi
}

src_configure() {
	local myconf
	#--with-python b0rked hard
	unset PYTHON
	use python || myconf="${myconf} --without-python"

	# Rely on precompiled gtk-doc files,
	# https://wiki.gentoo.org/wiki/Project:GNOME/Gnome_Team_Ebuild_Policies#gtk-doc
	econf \
		--disable-gtk-doc \
		--without-gucharmap \
		$(use_enable static-libs static) \
		${myconf}
}

src_install() {
	default

	if use python ; then
		find "${D}$(python_get_sitedir)" \( -name "*.la" -o -name "*.a" \) -type f -delete || die
	fi
	if ! use static-libs ; then
		find "${ED}" -name "*.la" -type f -delete || die
	fi
}
