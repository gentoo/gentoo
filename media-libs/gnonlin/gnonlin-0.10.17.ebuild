# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="Gnonlin is a set of GStreamer elements to ease the creation of non-linear multimedia editors"
HOMEPAGE="http://gnonlin.sourceforge.net"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0.10"
KEYWORDS="amd64 x86"
IUSE="doc test"

RDEPEND=">=media-libs/gstreamer-0.10.30:0.10
	 >=media-libs/gst-plugins-base-0.10.30:0.10"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( || (
		>=dev-util/gtk-doc-am-1.13
		>=dev-util/gtk-doc-1.3 ) )
	test? ( dev-libs/check
		media-libs/gst-plugins-good:0.10 )" # videomixer

src_configure() {
	econf \
		$(use_enable doc gtk-doc) \
		$(use_enable doc docbook)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README RELEASE

	# For some reason, make install doesn't do this
	if use doc; then
		local htmldir="/usr/share/gtk-doc/html"
		cd "${S}/docs/libs/html"
		gtkdoc-rebase --html-dir=${htmldir} || die "gtkdoc-rebase failed"
		insinto "${htmldir}/gnonlin"
		doins "${S}"/docs/libs/html/* || die "doins docs failed"
	fi
}
