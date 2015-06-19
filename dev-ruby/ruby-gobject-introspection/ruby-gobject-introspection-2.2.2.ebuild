# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gobject-introspection/ruby-gobject-introspection-2.2.2.ebuild,v 1.1 2014/10/17 01:03:26 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

inherit ruby-ng-gnome2

RUBY_S=ruby-gnome2-all-${PV}/gobject-introspection

DESCRIPTION="Ruby GObjectIntrosprction bindings"
KEYWORDS="~amd64 ~ppc"
IUSE=""

DEPEND="${DEPEND} dev-libs/gobject-introspection"
RDEPEND="${RDEPEND} dev-libs/gobject-introspection"

ruby_add_rdepend ">=dev-ruby/ruby-glib2-${PV}"

all_ruby_prepare() {
	sed -i -e "/notify/d" test/gobject-introspection-test-utils.rb || die
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die
}
