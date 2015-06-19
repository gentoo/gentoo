# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/robots/robots-0.10.1-r2.ebuild,v 1.5 2015/04/11 15:25:44 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README"

inherit ruby-fakegem

DESCRIPTION="A simple Ruby library to parse robots.txt"
HOMEPAGE="https://rubygems.org/gems/robots"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e 's:rake/rdoctask:rdoc/task:' Rakefile || die
}
