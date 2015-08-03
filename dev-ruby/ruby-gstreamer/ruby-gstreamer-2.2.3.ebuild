# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gstreamer/ruby-gstreamer-2.2.3.ebuild,v 1.5 2015/08/03 13:49:04 ago Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby GStreamer bindings"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="${RDEPEND}
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0"
DEPEND="${DEPEND}
	dev-libs/gobject-introspection
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0"
