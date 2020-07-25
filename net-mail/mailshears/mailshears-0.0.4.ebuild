# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25"

# The tests are dangerous and shouldn't be run by anyone!
# They mess with your local postgres databases.
RUBY_FAKEGEM_RECIPE_TEST=none
RUBY_FAKEGEM_RECIPE_DOC=yard
RUBY_FAKEGEM_EXTRADOC="doc/${PN}.example.conf.yml"

inherit ruby-fakegem

DESCRIPTION="Mangle your mail garden"
HOMEPAGE="http://michael.orlitzky.com/code/mailshears.xhtml"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/pg-1.2 <dev-ruby/pg-2"

all_ruby_install() {
	all_fakegem_install

	doman "doc/man1/${PN}.1"
}
