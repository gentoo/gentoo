# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Provides a mailcap-like MIME Content-Type lookup for Ruby"
HOMEPAGE="https://github.com/mime-types/ruby-mime-types"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest:5 dev-ruby/minitest-bonus-assertions:2 )"

ruby_add_rdepend ">=dev-ruby/mime-types-data-3.2015:3"

all_ruby_prepare() {
	# Avoid unneeded developer-only dependencies.
	sed -i -e '/\(focus\|rg\)/ s:^:#:' \
		-e 's:fivemat/::' test/minitest_helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
