# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="rspec-pending_for.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Mark specs pending or skipped for specific Ruby engine / version combinations"
HOMEPAGE="https://github.com/pboling/rspec-pending_for"
SRC_URI="https://github.com/pboling/rspec-pending_for/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend "
	dev-ruby/rspec-core
	dev-ruby/ruby_engine:2
	dev-ruby/ruby_version:1
"

all_ruby_prepare() {
	sed -i -e '/simplecov/ s:^:#:' spec/spec_helper.rb || die
}
