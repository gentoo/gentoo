# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md user_guide.md"

inherit ruby-fakegem

DESCRIPTION="Generalized implementation of the middleware abstraction for Ruby"
HOMEPAGE="https://github.com/mitchellh/middleware"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86"
SLOT="0"
IUSE=""

all_ruby_prepare() {
	# Avoid test failing with rspec 2.14+
	sed -i -e '/should raise an error if an invalid middleware is given/,/^  end/ s:^:#:' spec/middleware/runner_spec.rb
}
