# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="localhost.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Manage a local CA for self-signed localhost development servers"
HOMEPAGE="https://github.com/socketry/localhost"
SRC_URI="https://github.com/socketry/localhost/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm64 ~sparc ~x86"
SLOT="$(ver_cut 1)"
IUSE=""

# Skip tests for now since they require a lot of
# dependencies and this package blocks a security bug.
RESTRICT="test"

#ruby_add_bdepend "test? ( dev-ruby/async-rspec ) "

all_ruby_prepare() {
	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/covered/ s:^:#:' spec/spec_helper.rb || die
}
