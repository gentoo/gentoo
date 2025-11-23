# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md user_guide.md"

inherit ruby-fakegem

DESCRIPTION="Generalized implementation of the middleware abstraction for Ruby"
HOMEPAGE="https://github.com/mitchellh/middleware"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86"

all_ruby_prepare() {
	# Avoid test failing with rspec 2.14+
	sed -i -e '/should raise an error if an invalid middleware is given/,/^  end/ s:^:#:' spec/middleware/runner_spec.rb
}
