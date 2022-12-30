# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Creates temporary files and directories for testing"
HOMEPAGE="https://github.com/bhb/test_construct"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv x86"
IUSE=""

ruby_add_bdepend "test? (
	>=dev-ruby/minitest-5.0.8
	dev-ruby/mocha:1.0
	dev-ruby/rspec:3
)"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die

	sed -i -e '1igem "mocha", "<2"' test/test_helper.rb || die
}
