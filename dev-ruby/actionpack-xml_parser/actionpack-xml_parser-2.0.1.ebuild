# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="XML parameters parser for Action Pack (removed from core in Rails 4.0)"
HOMEPAGE="https://github.com/rails/actionpack-xml_parser"
SRC_URI="https://github.com/rails/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="2"
IUSE=""

ruby_add_rdepend "=dev-ruby/actionpack-5*:* =dev-ruby/railties-5*:*"

all_ruby_prepare() {
	sed -i -e "/bundler/d" Rakefile test/helper.rb || die
	sed -i -e '1igem "actionpack", "~>5.2"' test/helper.rb || die

	# Skip test that is not compatible with Rails 5.2
	sed -i -e '/occurring a parse error if parsing unsuccessful/askip "rails 5.2"' test/xml_params_parsing_test.rb || die
}

each_ruby_test() {
	MT_NO_PLUGINS=true ${RUBY} -Ilib:.:test -e "Dir['test/*_test.rb'].each{|f| require f}" || die
}
