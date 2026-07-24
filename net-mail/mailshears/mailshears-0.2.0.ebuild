# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ruby40 is fine, but needs dev-ruby/yard to support it
USE_RUBY="ruby32 ruby33 ruby34"

# The tests are dangerous and shouldn't be run by anyone!
# They mess with your local postgres databases.
RUBY_FAKEGEM_RECIPE_TEST=none
RUBY_FAKEGEM_RECIPE_DOC=yard
RUBY_FAKEGEM_EXTRADOC="doc/${PN}.example.conf.yml"

inherit ruby-fakegem

DESCRIPTION="Mangle your mail garden"
HOMEPAGE="https://michael.orlitzky.com/code/mailshears.xhtml"
SRC_URI="https://michael.orlitzky.com/code/releases/${P}.gem"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

ruby_add_rdepend ">=dev-ruby/pg-1.2 <dev-ruby/pg-2"

all_ruby_install() {
	all_fakegem_install

	doman "doc/man1/${PN}.1"
}
