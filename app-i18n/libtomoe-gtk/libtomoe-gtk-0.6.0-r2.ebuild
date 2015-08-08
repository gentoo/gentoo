# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="python? 2"

inherit autotools eutils python

MY_P="tomoe-gtk-${PV}"
DESCRIPTION="Tomoe GTK+ interface widget library"
HOMEPAGE="http://tomoe.sourceforge.jp/"
SRC_URI="mirror://sourceforge/tomoe/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc +gucharmap python static-libs"

RDEPEND=">=app-i18n/tomoe-0.6.0[python?]
	python? (
		dev-python/pygtk:2
		dev-python/pygobject:2
	)
	gucharmap? ( gnome-extra/gucharmap:0 )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
	sys-devel/gettext
	doc? ( >=dev-util/gtk-doc-1.4 )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use python ; then
		python_set_active_version 2
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
	#--with-python b0rked
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
		find "${ED}$(python_get_sitedir)" \( -name "*.la" -o -name "*.a" \) -type f -delete || die
	fi
	if ! use static-libs ; then
		find "${ED}" -name "*.la" -type f -delete || die
	fi

	dodoc AUTHORS ChangeLog NEWS README || die
}
