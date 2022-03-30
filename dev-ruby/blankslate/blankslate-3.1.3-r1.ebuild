# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Base class with almost all of the methods from Object and Kernel being removed"
HOMEPAGE="https://rubygems.org/gems/blankslate"

IUSE=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv sparc x86"

all_ruby_prepare() {
	# Avoid test failing with rspec 2.x.
	sed -i -e '/cleanliness/,/^  end/ s:^:#:' spec/blankslate_spec.rb || die
}
