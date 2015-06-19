# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rdiscount/rdiscount-1.6.8-r2.ebuild,v 1.11 2015/01/17 19:40:01 ago Exp $

EAPI=5

# Has a native extension without jruby support.
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_TEST="test:unit"

RUBY_FAKEGEM_TASK_DOC="doc man"
RUBY_FAKEGEM_EXTRADOC="README.markdown"

inherit multilib ruby-fakegem

DESCRIPTION="Implementation of John Gruber's Markdown"
HOMEPAGE="http://github.com/rtomayko/rdiscount"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

ruby_add_bdepend "doc? ( app-text/ronn )"

all_ruby_prepare() {
	# Hanna is broken for us and therefore we don't have it in portage.
	sed -i -e 's/hanna/rdoc/' Rakefile || die

	# Remove rule that will force a rebuild when running tests.
	sed -i -e "/task 'test:unit' => \[:build\]/d" Rakefile || die

	# Provide RUBY variable no longer provided by rake.
	sed -i -e "1 iRUBY=${RUBY}" Rakefile || die
}

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
}

each_ruby_compile() {
	emake -Cext
	cp ext/*$(get_modname) lib/ || die
}

all_ruby_install() {
	all_fakegem_install

	doman man/rdiscount.1
}
