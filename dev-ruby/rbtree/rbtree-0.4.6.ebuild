# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTENSIONS=(./extconf.rb)

inherit ruby-fakegem

DESCRIPTION="A sorted associative collection that is implemented with a Red-Black Tree"
HOMEPAGE="https://rubygems.org/gems/rbtree"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/test_pp/aomit "Fragile for whitespace"' test.rb || die
}

each_ruby_test() {
	RUBY_LIB=lib ${RUBY} test.rb || die
}
