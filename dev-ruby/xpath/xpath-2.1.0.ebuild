# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="XPath is a Ruby DSL around a subset of XPath 1.0"
HOMEPAGE="https://github.com/jnicklas/xpath"
LICENSE="MIT"

KEYWORDS="amd64 ~arm ~arm64 ~hppa ~x86"
SLOT="2"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/nokogiri )"

all_ruby_prepare() {
	sed -i -e '/\(bundler\|pry\)/d' spec/spec_helper.rb || die
}
