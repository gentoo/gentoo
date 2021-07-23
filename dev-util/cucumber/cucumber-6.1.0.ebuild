# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27"

# Documentation task depends on sdoc which we currently don't have.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_BINWRAP="cucumber"

RUBY_FAKEGEM_GEMSPEC="cucumber.gemspec"

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios"
HOMEPAGE="https://github.com/aslakhellesoy/cucumber/wikis"
SRC_URI="https://github.com/cucumber/cucumber-ruby/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="cucumber-ruby-${PV}"
LICENSE="Ruby"

KEYWORDS="~amd64"
SLOT="0"
IUSE="examples test"

ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		dev-ruby/rspec:3
		>=dev-ruby/nokogiri-1.5.2
		>=dev-ruby/syntax-1.0.0
		dev-ruby/json
		>=dev-util/cucumber-3
	)"

ruby_add_rdepend "
	>=dev-ruby/builder-3.2.4:3.2
	>=dev-util/cucumber-core-9.0.1:9
	dev-util/cucumber-create-meta:4
	>=dev-util/cucumber-cucumber-expressions-12.1.1:12
	>=dev-util/cucumber-gherkin-18.1.0:18
	>=dev-util/cucumber-html-formatter-13.0.0:13
	>=dev-util/cucumber-messages-15.0.0:15
	>=dev-util/cucumber-wire-5.0.1:5
	>=dev-ruby/diff-lcs-1.4.4:0
	>=dev-ruby/mime-types-3.3.1:3
	>=dev-ruby/multi_test-0.1.2:0
	>=dev-ruby/sys-uname-1.2.2:1
"

all_ruby_prepare() {
	# Remove development dependencies from the gemspec that we don't
	# need or can't satisfy.
	sed -e '/\(coveralls\|spork\|simplecov\|bcat\|kramdown\|yard\|capybara\|octokit\|rack-test\|ramaze\|rubocop\|sinatra\|webrat\|mime-types\|rubyzip\)/d' \
		-e '/nokogiri/ s/1.8.1/1.8/' \
		-e "/json/ s/, '~> 1.8.6'//" \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid dependency on unpackaged packages
	sed -i -e '/\(cucumber-pro\|webrick\)/ s:^:#:' Gemfile || die

	# Avoid specs failing due to differing deprecation message
	rm -f spec/cucumber/deprecate_spec.rb || die

	# Avoid failing features on new delegate and forwardable behavior in ruby
#	rm -f features/docs/defining_steps/ambiguous_steps.feature features/docs/defining_steps/nested_steps.feature || die

	sed -i -e '/pry/ s:^:#:' cucumber.gemspec spec/spec_helper.rb || die

	rm -f Gemfile.lock || die
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
