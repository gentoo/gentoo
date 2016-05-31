# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem
SRC_URI="https://github.com/floehopper/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Adds a __metaclass__ method to all Ruby objects"
HOMEPAGE="https://github.com/floehopper/metaclass"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile test/test_helper.rb || die
}
