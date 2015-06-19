# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cucumber-core/cucumber-core-1.1.3.ebuild,v 1.1 2015/05/05 05:57:21 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="HISTORY.md README.md"

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios"
HOMEPAGE="http://github.com/aslakhellesoy/cucumber/wikis"
LICENSE="Ruby"

KEYWORDS="~amd64"
SLOT="0"
IUSE="examples test"

ruby_add_bdepend "
	test? (
		>=dev-ruby/unindent-1.0
		>=dev-ruby/kramdown-1.4.2 =dev-ruby/kramdown-1.4*
		dev-ruby/bundler
	)"

ruby_add_rdepend "
	>=dev-ruby/gherkin-2.12.0:0
"
