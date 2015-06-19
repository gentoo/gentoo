# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/climate_control/climate_control-0.0.3.ebuild,v 1.4 2014/07/25 13:20:46 mrueg Exp $

EAPI=5
# uses 1.9 syntax
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="NEWS README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Easily manage your environment"
HOMEPAGE="https://github.com/thoughtbot/climate_control"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/activesupport-3.0"

all_ruby_prepare() {
	# Avoid dependencies on simplecov and git.
	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die
	sed -i -e 's/git ls-files/echo ""/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
