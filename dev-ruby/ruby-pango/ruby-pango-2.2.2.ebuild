# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-pango/ruby-pango-2.2.2.ebuild,v 1.3 2014/10/27 19:54:37 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Pango bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND+=" >=x11-libs/pango-1.2.1"
RDEPEND+=" >=x11-libs/pango-1.2.1"

ruby_add_rdepend ">=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/rcairo-1.12.5"
ruby_add_bdepend ">=dev-ruby/rcairo-1.12.5"

all_ruby_prepare() {
	# Remove test depending on specific locales to be set up: bug 526248
	rm test/test-language.rb || die
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die
}
