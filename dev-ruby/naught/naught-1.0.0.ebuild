# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/naught/naught-1.0.0.ebuild,v 1.3 2015/03/22 17:06:21 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.markdown"

inherit ruby-fakegem

DESCRIPTION="A toolkit for building Null Objects in Ruby"
HOMEPAGE="https://github.com/avdi/naught"

LICENSE="MIT"
SLOT="5"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/^if/,/^end/ s:^:#:' spec/spec_helper.rb || die
}
