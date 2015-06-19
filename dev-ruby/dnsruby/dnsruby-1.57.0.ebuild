# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/dnsruby/dnsruby-1.57.0.ebuild,v 1.2 2015/04/03 13:16:26 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_DOCDIR="html"
RUBY_FAKEGEM_EXTRADOC="DNSSEC EXAMPLES README.md"
inherit ruby-fakegem

DESCRIPTION="A pure Ruby DNS client library"
HOMEPAGE="http://rubyforge.org/projects/dnsruby"

KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.4:5 )"

all_ruby_prepare() {
	sed -i -e "/[Cc]overall/d" Rakefile || die
}

each_ruby_test() {
	# only run offline tests
	#${RUBY} -I .:lib test/ts_dnsruby.rb || die "test failed"
	${RUBY} -I .:lib test/ts_offline.rb || die "test failed"
}
