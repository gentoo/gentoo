# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/connection_pool/connection_pool-2.2.0.ebuild,v 1.3 2015/07/08 04:30:29 jer Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="Changes.md README.md"

inherit ruby-fakegem

DESCRIPTION="Generic connection pooling for Ruby"
HOMEPAGE="https://github.com/mperham/connection_pool"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc64"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/minitest-5 )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' connection_pool.gemspec || die
	sed -i -e '/bundler/d' Rakefile || die
}
