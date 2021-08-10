# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_EXTRADOC="Readme.md"
RUBY_FAKEGEM_EXTRAINSTALL="render"

inherit ruby-fakegem

DESCRIPTION="A syntax highlighting engine based on Textpow"
HOMEPAGE="https://github.com/grosser/ultraviolet"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/textpow-1.3.0"

all_ruby_prepare() {
	sed -i -e '/rdoc_patter/d' Rakefile || die
	sed -i -e '/git ls-files/d' ultraviolet.gemspec || die
}
