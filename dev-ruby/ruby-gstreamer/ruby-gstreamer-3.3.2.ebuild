# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

inherit virtualx ruby-ng-gnome2

DESCRIPTION="Ruby GStreamer bindings"
KEYWORDS="amd64 ~ppc ~x86"
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
	# Avoid native installer
	sed -i -e '/native-package-installer/ s:^:#: ; /^\s*setup_homebrew_libffi/ s:^:#:' ../glib2/lib/mkmf-gnome2.rb || die

	# Avoid compilation of dependencies during test.
	sed -i -e '/system/,/^  end/ s:^:#:' test/run-test.rb || die
}

each_ruby_test() {
	virtx ${RUBY} test/run-test.rb
}
