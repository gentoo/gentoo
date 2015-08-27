# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Glib2 bindings"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""
RDEPEND+=" >=dev-libs/glib-2"
DEPEND+=" >=dev-libs/glib-2"

ruby_add_bdepend "dev-ruby/pkg-config
	test? ( >=dev-ruby/test-unit-2 )"

RUBY_PATCHES="${FILESDIR}/${P}-glib-2.44.patch" #554126

all_ruby_prepare() {
	# Our sandbox always provides LD_PRELOAD in the environment.
	sed -i -e 's/unless ENV.empty?/unless (ENV.keys - ["LD_PRELOAD"]).empty?/' test/test_spawn.rb || die
}

each_ruby_configure() {
	${RUBY} extconf.rb || die "extconf.rb failed"
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die
}
