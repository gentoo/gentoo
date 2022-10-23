# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

inherit ruby-fakegem

DESCRIPTION="A simple opinionated mocking framework"
HOMEPAGE="https://github.com/ryanong/spy"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e "/bundler/d" -e "/pry/d" -e "/[Cc]overalls/d" -e '/[Rr]eporters/d' Rakefile test/test_helper.rb || die
}
