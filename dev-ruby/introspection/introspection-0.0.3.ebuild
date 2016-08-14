# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

# No documentation task
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Dynamic inspection of the hierarchy of method definitions on a Ruby object"
HOMEPAGE="http://jamesmead.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/metaclass-0.0.1 >=dev-ruby/instantiator-0.0.3"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile test/test_helper.rb || die
}
