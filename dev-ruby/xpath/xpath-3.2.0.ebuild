# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="XPath is a Ruby DSL around a subset of XPath 1.0"
HOMEPAGE="https://github.com/jnicklas/xpath"
LICENSE="MIT"

KEYWORDS="amd64 ~arm ~arm64 ~hppa ~x86"
SLOT="3"
IUSE=""

ruby_add_rdepend ">=dev-ruby/nokogiri-1.8:0"

all_ruby_prepare() {
	sed -i -e '/\(bundler\|pry\)/d' spec/spec_helper.rb || die
}
