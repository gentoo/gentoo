# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit eutils ruby-fakegem

DESCRIPTION="A linter for puppet DSL"
HOMEPAGE="http://puppet-lint.com/"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

ruby_add_bdepend "test? (
	dev-ruby/rspec-its:1
	dev-ruby/rspec-collection_matchers:1 )"
