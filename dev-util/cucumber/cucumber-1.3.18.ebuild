# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cucumber/cucumber-1.3.18.ebuild,v 1.2 2015/03/13 06:47:40 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

# Documentation task depends on sdoc which we currently don't have.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="none"
RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_GEMSPEC="cucumber.gemspec"

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios"
HOMEPAGE="http://github.com/aslakhellesoy/cucumber/wikis"
LICENSE="Ruby"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE="examples test"

ruby_add_bdepend "
	test? (
		>=dev-ruby/rspec-2.13.0
		>=dev-ruby/nokogiri-1.5.2
		>=dev-ruby/syntax-1.0.0
		>=dev-util/aruba-0.5.2
		>=dev-ruby/json-1.7
		dev-ruby/bundler
		>=dev-util/cucumber-1.3
		dev-ruby/rubyzip:0
	)"

ruby_add_rdepend "
	>=dev-ruby/builder-2.1.2
	>=dev-ruby/diff-lcs-1.1.3
	>=dev-ruby/gherkin-2.12.0:0
	>=dev-ruby/multi_json-1.7.5
	>=dev-ruby/multi_test-0.1.1
"

all_ruby_prepare() {
	# Remove development dependencies from the gemspec that we don't
	# need or can't satisfy.
	sed -i -e '/\(spork\|simplecov\|bcat\|kramdown\|yard\|capybara\|rack-test\|ramaze\|sinatra\|webrat\|mime-types\|rubyzip\)/d' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Fix too-strict test dependencies
	sed -e '/nokogiri/ s/~> 1.5.2/>= 1.5.2/' \
		-e '/aruba/ s/= 0.5.2/~> 0.5/' \
		-e '/rake/ s/10.2/10.5/' -i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Make sure spork is run in the right interpreter
	sed -i -e 's/#{Spork::BINARY}/-S #{Spork::BINARY}/' features/support/env.rb || die
	rm features/drb_server_integration.feature || die

	# Avoid json, they most likely fail due to multi_json weirdness.
	rm features/json_formatter.feature || die
	# Avoid features that break with newer rspec versions.
	sed -i -e '369,398d' features/background.feature || die

	# Avoid dependency on git
	sed -i -e '/git ls-files/d' cucumber.gemspec || die
}

each_ruby_test() {
	ruby-ng_rspec
	RUBYLIB=lib ${RUBY} -Ilib bin/cucumber features || die "Features failed"
}

all_ruby_install() {
	all_fakegem_install

	if use examples; then
		cp -pPR examples "${D}/usr/share/doc/${PF}" || die "Failed installing example files."
	fi
}
