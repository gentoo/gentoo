# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24"

# Documentation task depends on sdoc which we currently don't have.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="none"
RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_GEMSPEC="cucumber.gemspec"

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios"
HOMEPAGE="https://github.com/aslakhellesoy/cucumber/wikis"
LICENSE="Ruby"

KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ia64 ppc ppc64 sparc x86"
SLOT="0"
IUSE="examples test"

ruby_add_bdepend "
	test? (
		dev-ruby/rspec:3
		dev-ruby/bundler
		>=dev-ruby/nokogiri-1.5.2
		>=dev-ruby/syntax-1.0.0
		>=dev-util/aruba-0.6.1 =dev-util/aruba-0.6*
		>=dev-ruby/json-1.7
		>=dev-util/cucumber-2
		>=dev-ruby/mime-types-2.99:2
	)"

ruby_add_rdepend "
	>=dev-ruby/builder-2.1.2:*
	>=dev-util/cucumber-core-1.5.0:0
	>=dev-util/cucumber-wire-0.0.1:0
	>=dev-ruby/diff-lcs-1.1.3
	>=dev-ruby/gherkin-4.0:4
	>=dev-ruby/multi_json-1.7.5
	>=dev-ruby/multi_test-0.1.2
"

all_ruby_prepare() {
	# Remove development dependencies from the gemspec that we don't
	# need or can't satisfy.
	sed -i -e '/\(coveralls\|spork\|simplecov\|bcat\|kramdown\|yard\|capybara\|rack-test\|ramaze\|sinatra\|webrat\|mime-types\|rubyzip\)/d' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid dependency on unpackaged cucumber-pro
	sed -i -e '/cucumber-pro/ s:^:#:' Gemfile || die

	# Avoid harmless failing spec
	sed -i -e '/converts the snapshot path to a relative path/,/end/ s:^:#:' \
		spec/cucumber/formatter/html_spec.rb || die

	# Avoid specs that fail due to changes in the ruby backtrace,
	# introduced in newer versions of dev-lang/ruby, bug 628580
	rm -f features/docs/defining_steps/nested_steps.feature

	# Avoid dependency on git
	sed -i -e '/executables/ s/=.*/= ["cucumber"]/' \
		-e '/git ls-files/d' cucumber.gemspec || die

	sed -i -e '/pry/ s:^:#:' cucumber.gemspec spec/spec_helper.rb || die
}

each_ruby_prepare() {
	# Use the right interpreter
	sed -i -e 's:ruby:'${RUBY}':' features/lib/step_definitions/ruby_steps.rb || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec
	CUCUMBER_USE_RELEASED_CORE=true PATH="${S}"/bin:${PATH} RUBYLIB="${S}"/lib ${RUBY} -Ilib bin/cucumber features || die "Features failed"
}

all_ruby_install() {
	all_fakegem_install

	if use examples; then
		cp -pPR examples "${D}/usr/share/doc/${PF}" || die "Failed installing example files."
	fi
}
