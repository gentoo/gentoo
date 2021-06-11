# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="task"
RUBY_FAKEGEM_DOCDIR="htmldoc/rdoc"
RUBY_FAKEGEM_EXTRADOC="AUTHORS THANKS"
RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="A template-based static website generator"
HOMEPAGE="https://webgen.gettalong.org"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="builder doc highlight markdown"

ruby_add_bdepend "doc? ( dev-ruby/rdoc )
	test? (
		dev-ruby/minitest:5
		dev-ruby/rdiscount
		>=dev-ruby/sass-3.2:* )"

ruby_add_rdepend ">=dev-ruby/cmdparse-3.0.1:3
	>=dev-ruby/systemu-2.5 =dev-ruby/systemu-2*
	>=dev-ruby/kramdown-2.3:2
	builder? ( >=dev-ruby/builder-2.1.0:* )
	highlight? ( >=dev-ruby/coderay-1.0 )
	markdown? ( dev-ruby/maruku )"

all_ruby_prepare() {
	# Avoid a test fragile for sass version differences
	sed -i -e '/test_static_call/,/^  end/ s:^:#:' test/webgen/content_processor/test_sass.rb || die
	# Avoid a test with fragile whitespace tests
	rm -f test/webgen/content_processor/test_haml.rb || die

	# Avoid tests for rdoc since that requires an obsolete version
	sed -i -e '/def test_create_nodes/askip' test/webgen/path_handler/test_api.rb || die

	# Avoid tests for unpackaged dependencies
	rm -f test/webgen/content_processor/test_{css_minify,tikz}.rb || die
}

all_ruby_install() {
	all_fakegem_install

	doman man/man1/webgen.1
}
