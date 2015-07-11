# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gstreamer/ruby-gstreamer-2.2.5.ebuild,v 1.2 2015/07/11 06:48:10 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit virtualx ruby-ng-gnome2

DESCRIPTION="Ruby GStreamer bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="${RDEPEND}
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0"
DEPEND="${DEPEND}
	dev-libs/gobject-introspection
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0"

ruby_add_rdepend "
	~dev-ruby/ruby-glib2-${PV}
	~dev-ruby/ruby-gobject-introspection-${PV}
"

all_ruby_prepare() {
	# Avoid compilation of dependencies during test.
	sed -i -e '/system/,/^  end/ s:^:#:' test/run-test.rb || die
}

each_ruby_test() {
	VIRTUALX_COMMAND="${RUBY} test/run-test.rb"
	virtualmake || die
}
