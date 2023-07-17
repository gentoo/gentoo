# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_GEMSPEC="actionpack-xml_parser.gemspec"

inherit ruby-fakegem

DESCRIPTION="XML parameters parser for Action Pack (removed from core in Rails 4.0)"
HOMEPAGE="https://github.com/rails/actionpack-xml_parser"
SRC_URI="https://github.com/rails/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="2"
IUSE=""

ruby_add_rdepend "
	|| ( dev-ruby/actionpack:6.1 )
	|| ( dev-ruby/railties:6.1 )
"

ruby_add_bdepend "test? ( =dev-ruby/railties-6* )"

all_ruby_prepare() {
	sed -i -e "/bundler/d" Rakefile test/helper.rb || die
	sed -i -e '1igem "actionpack", "~>6.0"' test/helper.rb || die

	# Skip test that is not compatible with Rails 5.2
	sed -i -e '/occurring a parse error if parsing unsuccessful/askip "rails 5.2"' test/xml_params_parsing_test.rb || die
}

each_ruby_test() {
	MT_NO_PLUGINS=true ${RUBY} -Ilib:.:test -e "Dir['test/*_test.rb'].each{|f| require f}" || die
}
