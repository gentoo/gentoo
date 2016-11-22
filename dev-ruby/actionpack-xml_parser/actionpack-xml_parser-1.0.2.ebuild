# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="XML parameters parser for Action Pack (removed from core in Rails 4.0)"
HOMEPAGE="https://github.com/rails/actionpack-xml_parser"
SRC_URI="https://github.com/rails/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/actionpack-4.0.0:* <dev-ruby/actionpack-5:*"
ruby_add_bdepend "test? ( >=dev-ruby/activesupport-4.0.0 )"

all_ruby_prepare() {
	sed -i -e "/bundler/d" Rakefile test/helper.rb || die
	sed -i -e '1igem "actionpack", "~>4.0"' test/helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test test/xml_params_parsing_test.rb || die
}
