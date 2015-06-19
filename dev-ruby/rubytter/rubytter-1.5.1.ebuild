# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rubytter/rubytter-1.5.1.ebuild,v 1.4 2014/12/19 13:27:36 ago Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc examples/*"

inherit ruby-fakegem

DESCRIPTION="Rubytter is a simple twitter library"
HOMEPAGE="http://wiki.github.com/jugyo/rubytter"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/json-1.1.3 >=dev-ruby/oauth-0.3.6"

all_ruby_prepare() {
	sed -i -e '/bundler/d' -e '/check_dependencies/ s:^:#:' Rakefile || die
}
