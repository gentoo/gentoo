# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

USE_RUBY="ruby26 ruby27 ruby30"

inherit ruby-fakegem
DESCRIPTION="Gem provides enforced-type functionality to Arrays"
HOMEPAGE="https://github.com/yaauie/typed-array"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""

all_ruby_prepare() {
	# There is a trash...
	rm "${S}"/lib/typed-array/.DS_Store || die
}
