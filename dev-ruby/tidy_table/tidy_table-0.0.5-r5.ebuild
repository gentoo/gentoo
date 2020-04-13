# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="Tool to convert an array of struct into an HTML table"
HOMEPAGE="https://github.com/topfunky/tidy_table"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

all_ruby_prepare() {
	# Remove reference to RSpec 1
	sed -i -e '/spec/d' -e '1irequire "date"' spec/spec_helper.rb || die

	# Remove metadata so a stub gemspec will be created to avoid the
	# wrong runtime dependency on dev-ruby/hoe.
	rm -f ../metadata || die
}
