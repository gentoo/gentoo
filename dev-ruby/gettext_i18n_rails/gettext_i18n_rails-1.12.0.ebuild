# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="Readme.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="gettext_i18n_rails.gemspec"

inherit ruby-fakegem

DESCRIPTION="FastGettext / Rails integration"
HOMEPAGE="https://github.com/grosser/gettext_i18n_rails"
SRC_URI="https://github.com/grosser/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_bdepend "test? (
	dev-ruby/rails:7.0
	dev-ruby/activerecord:7.0[sqlite]
	dev-ruby/temple
	dev-ruby/ruby-gettext
	dev-ruby/haml
	dev-ruby/slim
)"

ruby_add_rdepend ">=dev-ruby/fast_gettext-0.9.0:*"

all_ruby_prepare() {
	rm Gemfile Gemfile.lock || die

	sed -i -e 's/git ls-files/find/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Remove specs for slim and hamlet, template engines we don't package.
	rm spec/gettext_i18n_rails/slim_parser_spec.rb spec/gettext_i18n_rails/haml_parser_spec.rb || die

	# Test against specific Rails version
	sed -e '1igem "rails", "~>7.0.0"' -i spec/spec_helper.rb || die
}
