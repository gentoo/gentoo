# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/dust/dust-0.1.7-r2.ebuild,v 1.4 2015/02/01 12:04:49 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="Descriptive block syntax definition for Test::Unit"
HOMEPAGE="http://dust.rubyforge.org/"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

# Remove a long-obsolete rubygems method.
all_ruby_prepare() {
	sed -i -e '/manage_gems/d' \
		-e '/gempackagetask/d' \
		-e '/GemPackageTask/,/end/d' \
		-e 's:rake/rdoctask:rdoc/task:' rakefile.rb || die "Unable to update rakefile.rb"

}

each_ruby_test() {
	${RUBY} -I. test/all_tests.rb || die
}
