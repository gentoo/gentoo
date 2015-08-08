# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils python-single-r1

MY_P="tomoe-gtk-${PV}"
DESCRIPTION="Tomoe GTK+ interface widget library"
HOMEPAGE="http://tomoe.sourceforge.jp/"
SRC_URI="mirror://sourceforge/tomoe/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +gucharmap python static-libs"

RDEPEND=">=app-i18n/tomoe-0.6.0
	python? (
		${PYTHON_DEPS}
		>=app-i18n/tomoe-0.6.0[python,${PYTHON_USEDEP}]
		dev-python/pygtk:2[${PYTHON_USEDEP}]
		dev-python/pygobject:2[${PYTHON_USEDEP}]
	)
	gucharmap? ( gnome-extra/gucharmap:0 )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
	sys-devel/gettext
	doc? ( >=dev-util/gtk-doc-1.4 )"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use python ; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	# Fix compilation with gucharmap-2.24, bug #243160
	epatch "${FILESDIR}/${P}-gucharmap2.patch"
	epatch "${FILESDIR}/${P}-underlinking.patch"

	eautoreconf
}

src_configure() {
	local myconf
	#--with-python b0rked hard
	unset PYTHON
	use python || myconf="${myconf} --without-python"

	econf \
		$(use_enable doc gtk-doc) \
		$(use_with gucharmap) \
		$(use_enable static-libs static) \
		${myconf} || die
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	if use python ; then
		find "${D}$(python_get_sitedir)" \( -name "*.la" -o -name "*.a" \) -type f -delete || die
	fi
	if ! use static-libs ; then
		find "${ED}" -name "*.la" -type f -delete || die
	fi

	dodoc AUTHORS ChangeLog NEWS README || die
}
