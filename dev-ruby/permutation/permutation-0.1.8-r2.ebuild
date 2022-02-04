# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="CHANGES README"

inherit multilib ruby-fakegem

DESCRIPTION="Library performing operations with permutations of sequences (strings, arrays)"
HOMEPAGE="https://flori.github.com/permutation"

LICENSE="|| ( Ruby-BSD BSD-2 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

each_ruby_test() {
	${RUBY} -Ilib test/test.rb || die
}
