# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

# Avoid the complexity of the "rake" recipe and run testrb-2 manually.
RUBY_FAKEGEM_RECIPE_TEST=none

# Same thing for the docs whose rake target just calls rdoc.
RUBY_FAKEGEM_RECIPE_DOC=rdoc
RUBY_FAKEGEM_EXTRADOC="ChangeLog README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Ruby library for easy read/write access to OLE compound documents"
HOMEPAGE="https://github.com/aquasync/ruby-ole"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

each_ruby_test() {
	ruby-ng_testrb-2 --pattern='test.*\.rb' test/
}
