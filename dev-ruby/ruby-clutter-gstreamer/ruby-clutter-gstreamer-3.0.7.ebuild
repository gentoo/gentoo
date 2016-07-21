# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

inherit virtualx ruby-ng-gnome2

DESCRIPTION="Ruby Clutter bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RUBY_S=ruby-gnome2-all-${PV}/clutter-gstreamer

DEPEND+=" media-libs/clutter-gst"
RDEPEND+=" media-libs/clutter-gst:*"

ruby_add_rdepend ">=dev-ruby/ruby-clutter-${PV}
	>=dev-ruby/ruby-gstreamer-${PV}"

all_ruby_prepare() {
	# Avoid unneeded dependency on test-unit-notify.
	sed -i -e '/notify/ s:^:#:' \
		../gobject-introspection/test/gobject-introspection-test-utils.rb \
		../clutter/test/clutter-test-utils.rb \
		test/clutter-gstreamer-test-utils.rb || die

	# Avoid compilation of dependencies during test.
	sed -i -e '/and have_make/,/^  end/ s:^:#:' test/run-test.rb || die
}

each_ruby_configure() {
	:
}

each_ruby_compile() {
	:
}

each_ruby_test() {
	VIRTUALX_COMMAND="${RUBY} test/run-test.rb"
	 virtualmake || die
}

each_ruby_install() {
	each_fakegem_install
}
