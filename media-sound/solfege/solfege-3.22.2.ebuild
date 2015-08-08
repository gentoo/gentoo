# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit python-single-r1

DESCRIPTION="GNU Solfege is a program written to help you practice ear training"
HOMEPAGE="http://www.solfege.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="alsa oss"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/pygtk-2.12
	gnome-base/librsvg
	alsa? ( dev-python/pyalsa )
	!oss? ( media-sound/timidity++ )"
DEPEND="${PYTHON_DEPS}
	dev-lang/swig
	sys-devel/gettext
	sys-apps/texinfo
	virtual/pkgconfig
	dev-libs/libxslt
	app-text/txt2man
	>=app-text/docbook-xsl-stylesheets-1.60"

RESTRICT="test"

src_prepare() {
	sed -i -e '/^CFLAGS/s:-I/usr/src/linux/include::' \
		solfege/soundcard/Makefile || die
}

src_configure() {
	local xslloc=$( xmlcatalog /etc/xml/catalog http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl | sed 's@file://@@' )

	econf \
		--enable-docbook-stylesheet=${xslloc} \
		$(use_enable oss oss-sound)
}

src_compile() {
	emake skipmanual=yes
}

src_install() {
	emake DESTDIR="${ED}" nopycompile=YES skipmanual=yes install
	dodoc AUTHORS *hange*og FAQ README
}
