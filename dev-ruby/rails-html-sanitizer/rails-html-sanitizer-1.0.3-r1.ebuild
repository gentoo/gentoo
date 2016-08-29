# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Sanitize HTML fragments in Rails applications"
HOMEPAGE="https://github.com/rafaelfranca/rails-html-sanitizer"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~arm ~ppc64 ~amd64-linux"
IUSE=""

ruby_add_rdepend "dev-ruby/loofah:0"

ruby_add_bdepend "test? ( dev-ruby/rails-dom-testing )"

all_ruby_prepare() {
	# Avoid tests failing with libxml2-2.9.3
	# https://github.com/rails/rails-html-sanitizer/issues/49
	sed -i -e '/test_\(strip_links_with_tags_in_tags\|strip_nested_tags\|should_sanitize_script_tag_with_multiple_open_brackets\|strip_tags_with_many_open_quotes\|strip_invalid_html\)/,/^  end/ s:^:#:' test/sanitizer_test.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}
