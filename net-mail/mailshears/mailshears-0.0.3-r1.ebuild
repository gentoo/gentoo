# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24"

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

ruby_add_rdepend ">=dev-ruby/pg-0.17 <dev-ruby/pg-1"

all_ruby_install() {
	all_fakegem_install

	doman "doc/man1/${PN}.1"
}
