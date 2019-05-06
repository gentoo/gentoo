# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="Readme.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="FastGettext / Rails integration"
HOMEPAGE="https://github.com/grosser/gettext_i18n_rails"
SRC_URI="https://github.com/grosser/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/rails:5.2 dev-ruby/activerecord:5.2[sqlite] dev-ruby/temple )"
ruby_add_rdepend ">=dev-ruby/fast_gettext-0.9.0:*"

all_ruby_prepare() {
	rm Gemfile Gemfile.lock || die

	# Remove specs for slim and hamlet, template engines we don't package.
	rm spec/gettext_i18n_rails/slim_parser_spec.rb spec/gettext_i18n_rails/haml_parser_spec.rb || die

	# Test against Rails 4.2.0
	sed -e '1igem "rails", "~>5.2.0"' -i spec/spec_helper.rb || die
}
