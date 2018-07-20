# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

inherit ruby-fakegem

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

DESCRIPTION="rdoc generator html with javascript search index"
HOMEPAGE="https://rubygems.org/gems/sdoc"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/rdoc-5.0"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/ s:^:#:' sdoc.gemspec || die

	sed -i -e '/bundler/ s:^:#:' spec/spec_helper.rb || die
}
