# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md user_guide.md"

inherit ruby-fakegem

DESCRIPTION="Generalized implementation of the middleware abstraction for Ruby"
HOMEPAGE="https://github.com/mitchellh/middleware"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

all_ruby_prepare() {
	# Avoid test failing with rspec 2.14+
	sed -i -e '/should raise an error if an invalid middleware is given/,/^  end/ s:^:#:' spec/middleware/runner_spec.rb
}
