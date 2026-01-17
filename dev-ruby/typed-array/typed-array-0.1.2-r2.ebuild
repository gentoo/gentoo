# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Gem provides enforced-type functionality to Arrays"
HOMEPAGE="https://github.com/yaauie/typed-array"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

all_ruby_prepare() {
	# There is a trash...
	rm "${S}"/lib/typed-array/.DS_Store || die

	sed -i -e 's/Fixnum/Integer/' spec/typed-array_spec.rb || die
}
