# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="yard"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Hooks Roadie into your Rails application to help with email generation"
HOMEPAGE="https://github.com/Mange/roadie-rails"
SRC_URI="https://github.com/Mange/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"

ruby_add_rdepend ">=dev-ruby/roadie-3.1:4
	|| ( dev-ruby/railties:7.0 dev-ruby/railties:6.1 dev-ruby/railties:6.0 dev-ruby/railties:5.2 )"
ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		dev-ruby/rails:7.0 dev-ruby/rails:6.0 dev-ruby/rails:5.2
		dev-ruby/rspec-rails
		dev-ruby/rspec-collection_matchers )"

all_ruby_prepare() {
	sed -i -e '/simplecov/ s:^:#:' Gemfile || die
	sed -i -e 's/git ls-files/find * -print/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid already removed rails version
	sed -i -e '/rails_51/ s:^:#:' spec/integration_spec.rb || die

	# Avoid dependency on optional bootsnap
	sed -i -e '/bootsnap/ s:^:#:' spec/railsapps/rails_70/Gemfile spec/railsapps/rails_70/config/boot.rb || die

	# Revert https://github.com/Mange/roadie-rails/commit/03acd8fddf651d43919e92db35d541ec4281c5fc for now
	# Fragile test which is affected by dependency versions (unclear which)
	sed -e 's/cd95a25e70dfe61add5a96e11d3fee0f29e9ba2b05099723d57bba7dfa725c8a/322506f9917889126e81df2833a6eecdf2e394658d53dad347e9882dd4dbf28e/' \
		-i spec/integration_spec.rb || die

}

each_ruby_prepare() {
	sed -i -e '/run_in_app_context/ s:bin/rails:'${RUBY}' -S bin/rails:' spec/support/rails_app.rb || die
}

each_ruby_test() {
	${RUBY} -S bundle exec rspec-3 spec || die
}
