# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

inherit ruby-fakegem

DESCRIPTION="Parsing Binary Data in Ruby"
HOMEPAGE="https://github.com/dmendel/bindata"

LICENSE="BSD-2"
SLOT="2"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest:5 )"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' Rakefile || die
	sed -i -e '/[Cc]overalls/d' test/test_helper.rb || die
}
