# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Creates temporary files and directories for testing"
HOMEPAGE="https://github.com/bhb/test_construct"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
IUSE=""

ruby_add_bdepend "test? (
	>=dev-ruby/minitest-5.0.8
	dev-ruby/mocha:2
	dev-ruby/rspec:3
)"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die

	sed -i -e '/mocha/ s/setup/minitest/' test/test_helper.rb || die
}
