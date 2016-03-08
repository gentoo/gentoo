# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

inherit ruby-fakegem

DESCRIPTION="A small web framework modeled after Ruby on Rails"
HOMEPAGE="https://wiki.github.com/camping/camping"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/rack-test >=dev-ruby/minitest-4:0 dev-ruby/tilt:0 )"

ruby_add_rdepend "
	>=dev-ruby/mab-0.0.3
	>=dev-ruby/rack-1.0:*"

all_ruby_prepare() {
	sed -i -e '1igem "minitest", "~> 4.0"; gem "tilt", "~>1.0"' test/test_helper.rb || die
}

each_ruby_test() {
	${RUBY} -S testrb test/app_*.rb || die
}
