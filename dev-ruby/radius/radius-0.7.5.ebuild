# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG QUICKSTART.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Powerful tag-based template system"
HOMEPAGE="https://github.com/jlong/radius"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/kramdown )"

all_ruby_prepare() {
	sed -i -e "/simplecov/,/end/d" -e "/coveralls/d" test/test_helper.rb || die
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
}
