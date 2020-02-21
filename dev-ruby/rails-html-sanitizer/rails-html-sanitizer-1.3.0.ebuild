# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Sanitize HTML fragments in Rails applications"
HOMEPAGE="https://github.com/rafaelfranca/rails-html-sanitizer"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE=""

ruby_add_rdepend ">=dev-ruby/loofah-2.3:0"

ruby_add_bdepend "test? ( dev-ruby/rails-dom-testing )"

all_ruby_prepare() {
	# Avoid tests that depend on nokogiri patches to libxml2.
	sed -i -e '/\(name_action\|attr\)_in_a_tag_in_safe_list_sanitizer/askip "libxml2"' test/sanitizer_test.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}
