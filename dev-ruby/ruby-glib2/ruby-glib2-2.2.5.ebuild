# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-glib2/ruby-glib2-2.2.5.ebuild,v 1.1 2015/07/09 09:20:08 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Glib2 bindings"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""
RDEPEND+=" >=dev-libs/glib-2"
DEPEND+=" >=dev-libs/glib-2"

ruby_add_bdepend "dev-ruby/pkg-config
	test? ( >=dev-ruby/test-unit-2 )"

all_ruby_prepare() {
	# Our sandbox always provides LD_PRELOAD in the environment.
	sed -i -e 's/unless ENV.empty?/unless (ENV.keys - ["LD_PRELOAD"]).empty?/' test/test_spawn.rb || die

	# Remove pregenerated Makefile since it will otherwise be shared by all targets.
	rm -f Makefile Makefile.lib ext/glib2/Makefile || die
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die
}
