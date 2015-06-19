# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/amq-client/amq-client-1.0.4.ebuild,v 1.4 2015/01/29 06:47:43 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.textile"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_BINWRAP=""

inherit versionator ruby-fakegem

DESCRIPTION="A fully-featured, low-level AMQP 0.9.1 client"
HOMEPAGE="http://github.com/ruby-amqp/amq-client"

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
