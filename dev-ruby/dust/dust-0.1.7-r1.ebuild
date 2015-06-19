# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/dust/dust-0.1.7-r1.ebuild,v 1.5 2014/07/12 09:04:25 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="Descriptive block syntax definition for Test::Unit"
HOMEPAGE="http://dust.rubyforge.org/"
LICENSE="MIT"

KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

# Remove a long-obsolete rubygems method.
all_ruby_prepare() {
	sed -i '/manage_gems/d' rakefile.rb || die "Unable to update rakefile.rb"
}

each_ruby_test() {
	${RUBY} -I. test/all_tests.rb || die
}
