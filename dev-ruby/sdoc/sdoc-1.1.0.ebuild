# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

inherit ruby-fakegem

DESCRIPTION="rdoc generator html with javascript search index"
HOMEPAGE="https://rubygems.org/gems/sdoc"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ppc ~x86"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/rdoc-5.0"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/ s:^:#:' sdoc.gemspec || die

	sed -i -e '/bundler/ s:^:#:' spec/spec_helper.rb || die

	# Avoid spec that appears to be broken with newer rdoc versions.
	sed -i -e '/should display SDoc version/askip' spec/rdoc_generator_spec.rb || die
}
