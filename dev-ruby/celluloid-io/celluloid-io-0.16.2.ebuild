# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

inherit ruby-fakegem

DESCRIPTION="Evented IO for Celluloid actors"
HOMEPAGE="https://github.com/celluloid/celluloid-io"
IUSE=""
SLOT="0"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

ruby_add_rdepend ">=dev-ruby/celluloid-0.16.0
	>=dev-ruby/nio4r-1.1.0"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' -e '/[Cc]overalls/d' spec/spec_helper.rb || die

	# Avoid DNS tests. They either assume localhost is 127.0.0.1 or
	# require network access.
	rm spec/celluloid/io/dns_resolver_spec.rb || die
}
