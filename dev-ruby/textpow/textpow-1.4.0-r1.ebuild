# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"
RUBY_FAKEGEM_GEMSPEC="textpow.gemspec"

inherit ruby-fakegem

SRC_URI="https://github.com/grosser/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="A library to parse and process Textmate bundles"
HOMEPAGE="http://textpow.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE=""

ruby_add_rdepend ">=dev-ruby/plist-3.0.1"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' textpow.gemspec || die
}
