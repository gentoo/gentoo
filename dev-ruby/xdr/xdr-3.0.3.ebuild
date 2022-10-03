# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"
RUBY_FAKEGEM_GEMSPEC="xdr.gemspec"

inherit ruby-fakegem

DESCRIPTION="Read/write XDR encoded data structures"
HOMEPAGE="https://github.com/astroband/ruby-xdr"
SRC_URI="https://github.com/astroband/ruby-xdr/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="ruby-${P}"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/activemodel-5.2.0:*
	>=dev-ruby/activesupport-5.2.0:*"

all_ruby_prepare() {
	sed -i -e '/bundler/,/pry/ s:^:#:' -e '/simplecov/,/^end/ s:^:#:' spec/spec_helper.rb || die

	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
}
