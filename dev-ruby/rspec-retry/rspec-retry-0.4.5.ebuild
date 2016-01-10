# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Retry intermittently failing rspec examples"
HOMEPAGE="https://github.com/NoRedInk/rspec-retry"
IUSE=""
SLOT="0"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm"

all_ruby_prepare() {
	sed -i -e '/pry/ s:^:#:' spec/spec_helper.rb || die
}
