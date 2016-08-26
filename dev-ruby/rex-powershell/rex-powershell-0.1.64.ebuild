# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

#RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Ruby Exploitation(Rex) library for generating/manipulating Powershell scripts"
HOMEPAGE="https://rubygems.org/gems/rex-powershell"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

# Specs are not packaged in the gem and source is not tagged upstream.
RESTRICT="test"

ruby_add_bdepend "dev-ruby/rex-random_identifier
		  dev-ruby/rex-text"
