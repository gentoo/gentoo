# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md TODO CONTRIBUTING.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Deep Freeze Ruby Objects"
HOMEPAGE="https://rubygems.org/gems/ice_nine https://github.com/dkubb/ice_nine"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"

# Some tests are broken on Ruby 3 and require a new release upstream.
RESTRICT="test"

all_ruby_prepare() {
	sed -e '/devtools/ s:^:#:' \
		-e "/devtools/aDir['./spec/shared/**/*.rb'].each(&Kernel.method(:require))" \
		-i spec/spec_helper.rb || die
}
