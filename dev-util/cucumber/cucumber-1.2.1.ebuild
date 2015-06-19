# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cucumber/cucumber-1.2.1.ebuild,v 1.14 2014/12/28 08:21:36 graaff Exp $

EAPI=2
USE_RUBY="ruby19"

# Documentation task depends on sdoc which we currently don't have.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="none"
RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_GEMSPEC="cucumber.gemspec"

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios"
HOMEPAGE="http://github.com/aslakhellesoy/cucumber/wikis"
LICENSE="Ruby"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
SLOT="0"
IUSE="examples"

ruby_add_bdepend "
	test? (
		>=dev-ruby/rspec-2.10.0
		>=dev-ruby/nokogiri-1.5.2
		>=dev-ruby/spork-0.9.0
		>=dev-ruby/syntax-1.0.0
		>=dev-util/aruba-0.4.6
	)"

ruby_add_rdepend "
	>=dev-ruby/builder-2.1.2
	>=dev-ruby/diff-lcs-1.1.3
	>=dev-ruby/gherkin-2.11.0
	>=dev-ruby/json-1.4.6
"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' Rakefile spec/spec_helper.rb || die
	rm Gemfile || die

	# Make sure spork is run in the right interpreter
	sed -i -e 's/#{Spork::BINARY}/-S #{Spork::BINARY}/' features/support/env.rb || die

	# Skip failing tests due to hash ordering
	sed -i -e '/when a specified profile does not exist/,/end/ s:^:#:' spec/cucumber/cli/configuration_spec.rb || die
	sed -i -e '/should allow Array of Hash/,/end/ s:^:#:' spec/cucumber/ast/table_spec.rb || die

	# Remove a feature for jruby that still runs on other rubies and
	# fails.
	rm features/backtraces.feature || die

	# Avoid dependency on git
	sed -i -e '/git ls-files/d' cucumber.gemspec || die
}

each_ruby_test() {
	ruby-ng_rspec
	${RUBY} -Ilib bin/cucumber features || die "Features failed"
}

all_ruby_install() {
	all_fakegem_install

	if use examples; then
		cp -pPR examples "${D}/usr/share/doc/${PF}" || die "Failed installing example files."
	fi
}
