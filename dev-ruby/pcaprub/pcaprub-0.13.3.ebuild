# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="FAQ.rdoc README.rdoc USAGE.rdoc"
RUBY_FAKEGEM_EXTENSIONS=(ext/pcaprub_c/extconf.rb)
RUBY_FAKEGEM_TASK_TEST="test"
inherit ruby-fakegem

DESCRIPTION="Libpcap bindings for ruby compat"
HOMEPAGE="https://rubygems.org/gems/pcaprub"

LICENSE="LGPL-2.1"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

DEPEND="net-libs/libpcap"
RDEPEND="net-libs/libpcap"

ruby_add_bdepend "
	test? (
		>=dev-ruby/rake-compiler-0.6.0
		dev-ruby/shoulda-context
	)
"

all_ruby_prepare() {
	sed -i \
		-e '/\(minitest\|shoulda-context\)/s:~>:>=:' \
		-e '/coveralls/d' \
		-e '/rubygems-tasks/d' \
		-e '/gem.*git/d' \
		Gemfile || die

	sed -i \
		-e '/rubygems\/tasks/d' \
		-e '/Gem::Tasks/d' \
		-e "/^require 'git'/,/end/ s/^/#/" \
		Rakefile || die

	sed -i -e '/coveralls/Id' test/test_helper.rb || die

	# Tests which need escalated privileges, network interfaces or other devices
	local privileged_tests=(
		test_set_datalink
		test_create_from_primitives
		test_filter
		test_lookupdev
		test_lookupnet
		test_monitor
		test_pcap_stats
		test_pcap_datalink
		test_pcap_inject
		test_pcap_next
		test_pcap_setfilter
		test_pcap_snapshot
	)

	local privileged_tests_expr=$(printf "%s\|" "${privileged_tests[@]}")
	privileged_tests_expr="${privileged_tests_expr::-2}"

	sed -i \
		-e "/def \(${privileged_tests_expr}\)/,/^  end/s/^/#/" \
		test/test_pcaprub_unit.rb || die
}
