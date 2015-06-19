# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/gettext_i18n_rails/gettext_i18n_rails-1.2.3.ebuild,v 1.2 2015/06/09 14:39:38 mrueg Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="Readme.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="FastGettext / Rails integration"
HOMEPAGE="https://github.com/grosser/gettext_i18n_rails"
SRC_URI="https://github.com/grosser/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/rails:4.0 dev-ruby/activerecord:4.0[sqlite] dev-ruby/temple )"
ruby_add_rdepend ">=dev-ruby/fast_gettext-0.9.0"

all_ruby_prepare() {
	rm Gemfile Gemfile.lock || die

	# Remove specs for slim and hamlet, template engines we don't package.
	rm spec/gettext_i18n_rails/slim_parser_spec.rb spec/gettext_i18n_rails/haml_parser_spec.rb || die

	# Test against Rails 4.0 (newer versions don't work and we don't use
	# appraisals for now).
	sed -e '1igem "rails", "~>4.0.0"' -i spec/spec_helper.rb || die
}
