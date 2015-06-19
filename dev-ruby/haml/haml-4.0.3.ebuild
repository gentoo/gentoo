# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/haml/haml-4.0.3.ebuild,v 1.7 2014/08/15 14:01:04 blueness Exp $

EAPI=5

USE_RUBY="ruby19"

RUBY_FAKEGEM_TASK_TEST="test"
RUBY_FAKEGEM_TASK_DOC="-Ilib doc"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md FAQ.md README.md REFERENCE.md"
RUBY_FAKEGEM_DOCDIR="doc"

inherit ruby-fakegem

DESCRIPTION="HAML - a ruby web page templating engine"
HOMEPAGE="http://haml-lang.com/"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="doc test"

RDEPEND="${RDEPEND} !!<dev-ruby/haml-3.1.8-r2"

ruby_add_rdepend "dev-ruby/tilt"

ruby_add_bdepend "
	test? (
		dev-ruby/minitest:0
		dev-ruby/nokogiri
		dev-ruby/rails
	)
	doc? (
		dev-ruby/yard
		dev-ruby/maruku
	)"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' \
		-e 's/gem "minitest"/gem "minitest", "~>4.0"/' \
		test/test_helper.rb || die
}
