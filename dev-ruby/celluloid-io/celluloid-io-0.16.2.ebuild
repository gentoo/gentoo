# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/celluloid-io/celluloid-io-0.16.2.ebuild,v 1.2 2015/07/11 20:15:09 zlogene Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

inherit ruby-fakegem

DESCRIPTION="Evented IO for Celluloid actors"
HOMEPAGE="https://github.com/celluloid/celluloid-io"
IUSE=""
SLOT="0"

LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

ruby_add_rdepend ">=dev-ruby/celluloid-0.16.0
	>=dev-ruby/nio4r-1.1.0"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' -e '/[Cc]overalls/d' spec/spec_helper.rb || die

	# Avoid DNS tests. They either assume localhost is 127.0.0.1 or
	# require network access.
	rm spec/celluloid/io/dns_resolver_spec.rb || die
}
