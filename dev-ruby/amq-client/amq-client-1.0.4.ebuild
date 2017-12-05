# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.textile"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_BINWRAP=""

inherit versionator ruby-fakegem

DESCRIPTION="A fully-featured, low-level AMQP 0.9.1 client"
HOMEPAGE="https://github.com/ruby-amqp/amq-client"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/amq-protocol-1.2.0 dev-ruby/eventmachine"

ruby_add_bdepend "test? ( dev-ruby/evented-spec )"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undler/ s:^:#:' -e '/effin_utf8/ s:^:#:' spec/spec_helper.rb || die
	sed -i -e '7i require "evented-spec"' spec/spec_helper.rb || die

	# Drop integration tests since these require a running AMQP server.
	rm -rf spec/integration spec/regression/bad_frame_slicing_in_adapters_spec.rb spec/unit/client_spec.rb || die
}
