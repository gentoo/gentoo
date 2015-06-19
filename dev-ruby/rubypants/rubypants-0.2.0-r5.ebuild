# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rubypants/rubypants-0.2.0-r5.ebuild,v 1.6 2015/05/09 05:59:28 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="A Ruby port of the SmartyPants PHP library"
HOMEPAGE="http://chneukirchen.org/repos/rubypants/README"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

all_ruby_prepare() {
	# the metadata format is ancient, and has quite a bit of trouble,
	# remove it and let it use a generated one.
	rm -f ../metadata || die
}

each_ruby_install() {
	ruby_fakegem_install_gemspec

	ruby_fakegem_newins rubypants.rb lib/rubypants.rb
}

each_ruby_test() {
	# The rakefile doesn't really implement it properly, so simply
	# replace it here.
	${RUBY} -I. test_rubypants.rb || die "tests failed"
}
