# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Descriptive configuration files for Ruby written in Ruby"
HOMEPAGE="https://github.com/TwP/loquacious"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

all_ruby_prepare() {
	sed -i -e 's/be_true/be true/' -e 's/be_false/be false/' spec/*_spec.rb || die
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*
}
