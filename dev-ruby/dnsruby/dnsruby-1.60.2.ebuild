# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_DOCDIR="html"
RUBY_FAKEGEM_EXTRADOC="DNSSEC EXAMPLES README.md"
inherit ruby-fakegem

DESCRIPTION="A pure Ruby DNS client library"
HOMEPAGE="https://github.com/alexdalitz/dnsruby"

KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.4:5 )"

all_ruby_prepare() {
	sed -i -e "/[Cc]overall/d" Rakefile || die
	sed -i -e '/display/d' \
		-e '/Display/,/^}/d' test/spec_helper.rb || die
}

each_ruby_test() {
	# only run offline tests
	#${RUBY} -I .:lib test/ts_dnsruby.rb || die "test failed"
	${RUBY} -I .:lib test/ts_offline.rb || die "test failed"
}
