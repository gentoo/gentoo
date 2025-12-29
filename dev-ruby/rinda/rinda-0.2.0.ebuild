# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="rinda.gemspec"

inherit ruby-fakegem

DESCRIPTION="The Linda distributed computing paradigm in Ruby"
HOMEPAGE="https://github.com/ruby/rinda"
SRC_URI="https://github.com/ruby/rinda/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

IUSE="test"

ruby_add_rdepend "
	dev-ruby/drb
	dev-ruby/forwardable
	dev-ruby/ipaddr
"

ruby_add_bdepend "test? ( dev-ruby/test-unit dev-ruby/test-unit-ruby-core )"

all_ruby_prepare() {
	sed -e 's/__dir__/"."/' \
		-e 's/__FILE__/"'${RUBY_FAKEGEM_GEMSPEC}'"/' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Ensure the new code in lib is tested also when calling out to
	# another ruby instance.
	sed -e '/rubybin/ s:-rdrb/drb:-Ilib -rdrb/drb:' \
		-i test/rinda/test_rinda.rb || die

	# Avoid tests requiring network device access
	sed -e '/test_\(make_socket\|ring_server\)_ipv6_multicast/aomit "Requires network access"' \
		-i test/rinda/test_rinda.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test:test/lib -e 'Dir["test/**/test_*.rb"].each{|f| require f}' || die
}
