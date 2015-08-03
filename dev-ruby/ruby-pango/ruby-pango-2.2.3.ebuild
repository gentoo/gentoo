# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-pango/ruby-pango-2.2.3.ebuild,v 1.5 2015/08/03 13:49:24 ago Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Pango bindings"
KEYWORDS="amd64 ~ppc x86"
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
