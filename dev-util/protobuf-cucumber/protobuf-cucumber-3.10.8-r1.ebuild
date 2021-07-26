# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Google Protocol Buffers serialization and RPC implementation for Ruby"
HOMEPAGE="https://github.com/ruby-protobuf/protobuf"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/activesupport-3.2:*
	dev-ruby/middleware
	dev-ruby/thor:*
	dev-ruby/thread_safe
"

ruby_add_bdepend "test? (
	dev-ruby/timecop
)"

all_ruby_prepare() {
	sed -i -e '/\(bundler\|pry\)/I s:^:#:' Rakefile spec/spec_helper.rb || die

	# Avoid unpackaged optional dependency
	rm -f spec/lib/protobuf/rpc/connectors/{ping,zmq}_spec.rb spec/functional/zmq_server_spec.rb || die
	rm -rf spec/lib/protobuf/rpc/servers/zmq || die
	sed -i -e '/context .zmq/,/^      end/ s:^:#:' spec/lib/protobuf/cli_spec.rb || die
}
