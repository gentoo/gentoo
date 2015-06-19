# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/tilt/tilt-1.4.1.ebuild,v 1.12 2015/04/27 08:59:38 ago Exp $

EAPI=5

# jruby fails tests
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md TEMPLATES.md"

inherit ruby-fakegem

DESCRIPTION="A thin interface over a Ruby template engines to make their usage as generic as possible"
HOMEPAGE="http://github.com/rtomayko/tilt"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? (
	dev-ruby/bluecloth
	dev-ruby/coffee-script
	dev-ruby/erubis
	dev-ruby/nokogiri )"

ruby_add_rdepend ">=dev-ruby/builder-2.0.0"

all_ruby_prepare() {
	# Recent kramdown versions handle quoting differently.
	rm test/tilt_kramdown_test.rb || die
}
