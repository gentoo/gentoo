# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/matchy/matchy-0.5.2-r1.ebuild,v 1.7 2015/04/18 07:09:42 graaff Exp $

EAPI=5

MY_OWNER="mcmire"

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

RUBY_FAKEGEM_NAME="${MY_OWNER}-${PN}"

inherit ruby-fakegem

DESCRIPTION="RSpec-esque matchers for use in Test::Unit"
HOMEPAGE="http://github.com/mcmire/matchy"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

all_ruby_prepare() {
	sed -i -e 's:rake/rdoctask:rdoc/task:' Rakefile || die
}

# workaround for ruby 1.9.2, sent upstream after 0.5.2
each_ruby_test() {
	RUBYLIB="$(pwd)${RUBYLIB+:${RUBYLIB}}" each_fakegem_test
}
