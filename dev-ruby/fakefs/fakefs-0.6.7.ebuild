# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/fakefs/fakefs-0.6.7.ebuild,v 1.1 2015/04/07 18:35:30 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="none"

# requires sdoc
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="CONTRIBUTORS README.markdown"

inherit ruby-fakegem eutils

DESCRIPTION="A fake filesystem. Use it in your tests"
HOMEPAGE="https://github.com/defunkt/fakefs"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "
	test? (
		>=dev-ruby/rspec-3.1:3
		>=dev-ruby/minitest-5.5
	)"

all_ruby_prepare() {
	# Remove bundler
	rm Gemfile || die

	# Avoid unneeded minitest-rg dependency.
	sed -i -e '1igem "minitest", "~>5.5"' \
		-e '/minitest\/rg/ s:^:#:' test/test_helper.rb || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec
	${RUBY} -Ilib:.:test -e 'Dir["test/**/*_test.rb"].each{|f| require f}' || die
}
