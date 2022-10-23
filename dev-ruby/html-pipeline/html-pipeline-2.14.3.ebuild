# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="html-pipeline.gemspec"

inherit ruby-fakegem

DESCRIPTION="GitHub HTML processing filters and utilities"
HOMEPAGE="https://github.com/gjtorikian/html-pipeline"
SRC_URI="https://github.com/gjtorikian/html-pipeline/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/activesupport-2:*
	>=dev-ruby/nokogiri-1.4
"

ruby_add_bdepend "test? (
	dev-ruby/commonmarker
	dev-ruby/rinku
	dev-ruby/redcloth
	dev-ruby/rouge
	dev-ruby/sanitize
)"

all_ruby_prepare() {
	sed -i -e '/\(bundler\|focus\)/ s:^:#:' Rakefile test/test_helper.rb || die
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid running tests for unpackaged optional dependencies
	# escape_utils, email_reply_parser, gemoji
	rm -f test/html/pipeline/{email_reply,emoji,plain_text_input,syntax_highlight,toc}_filter_test.rb || die
}
