# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rb-readline/rb-readline-0.5.2.ebuild,v 1.1 2015/01/01 07:53:09 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
inherit ruby-fakegem

DESCRIPTION="Ruby implementation of the GNU readline C library forked by r7"
HOMEPAGE="http://rubygems.org/gems/rb-readline-r7"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
DEPEND="test? ( dev-ruby/minitest
		dev-ruby/rake )"

all_ruby_prepare() {
	# Skip a test that fails when run in the ebuild environment.
	sed -i -e '/test_readline_with_default_parameters_does_not_error/,/end/ s:^:#:' test/test_readline.rb || die
}
