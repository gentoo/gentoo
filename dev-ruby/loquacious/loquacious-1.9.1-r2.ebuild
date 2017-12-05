# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Descriptive configuration files for Ruby written in Ruby"
HOMEPAGE="https://github.com/TwP/loquacious"

IUSE=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

all_ruby_prepare() {
	# Remove metadata because it confuses jruby.
	rm -f ../metadata || die
}

all_ruby_compile() {
	if use doc; then
		rdoc lib || die "Documentation generation failed."
	fi
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*
}
