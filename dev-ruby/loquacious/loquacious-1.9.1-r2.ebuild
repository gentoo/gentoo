# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/loquacious/loquacious-1.9.1-r2.ebuild,v 1.4 2015/05/09 05:57:04 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Descriptive configuration files for Ruby written in Ruby"
HOMEPAGE="http://github.com/TwP/loquacious"

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
