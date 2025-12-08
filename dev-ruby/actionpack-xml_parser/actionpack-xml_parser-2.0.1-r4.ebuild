# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_GEMSPEC="actionpack-xml_parser.gemspec"

inherit ruby-fakegem

DESCRIPTION="XML parameters parser for Action Pack (removed from core in Rails 4.0)"
HOMEPAGE="https://github.com/rails/actionpack-xml_parser"
SRC_URI="https://github.com/rails/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"

SLOT="2"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "
	|| ( dev-ruby/actionpack:7.2 dev-ruby/actionpack:7.1 dev-ruby/actionpack:7.0 )
	|| ( dev-ruby/railties:7.2 dev-ruby/railties:7.1 dev-ruby/railties:7.0 )
"

ruby_add_bdepend "test? ( =dev-ruby/railties-7* )"

all_ruby_prepare() {
	sed -i -e "/bundler/d" Rakefile test/helper.rb || die
	sed -e '1igem "actionpack", "~>7.2.0"' \
		-e '3irequire "active_support/core_ext/kernel/reporting.rb"' \
		-i test/helper.rb || die

	# Skip test that is not compatible with Rails 5.2
	sed -i -e '/occurring a parse error if parsing unsuccessful/askip "rails 5.2"' test/xml_params_parsing_test.rb || die
}

each_ruby_test() {
	MT_NO_PLUGINS=true ${RUBY} -Ilib:.:test -e "Dir['test/*_test.rb'].each{|f| require f}" || die
}
