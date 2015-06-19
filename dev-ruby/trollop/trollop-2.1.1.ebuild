# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/trollop/trollop-2.1.1.ebuild,v 1.7 2015/03/13 08:30:37 ago Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="FAQ.txt History.txt README.md"

inherit ruby-fakegem

DESCRIPTION="Trollop is a commandline option parser for Ruby"
HOMEPAGE="http://manageiq.github.io/trollop/"
LICENSE="MIT"

KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
SLOT="2"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/chronic )"

each_ruby_test() {
	MUTANT=true ${RUBY} -I lib test/test_trollop.rb || die "Tests failed."
}
