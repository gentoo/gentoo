# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rb-readline/rb-readline-0.5.2.ebuild,v 1.2 2015/05/04 01:59:02 zerochaos Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
inherit ruby-fakegem

DESCRIPTION="Ruby implementation of the GNU readline C library"
HOMEPAGE="http://rubygems.org/gems/rb-readline"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_bdepend "dev-ruby/rake
		>=dev-ruby/minitest-5.2"

all_ruby_prepare() {
	# Skip a test that fails when run in the ebuild environment.
	sed -i -e '/test_readline_with_default_parameters_does_not_error/,/end/ s:^:#:' test/test_readline.rb || die
}
