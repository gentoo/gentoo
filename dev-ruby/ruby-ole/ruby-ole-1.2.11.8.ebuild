# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-ole/ruby-ole-1.2.11.8.ebuild,v 1.1 2015/02/14 18:58:36 mjo Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

# Avoid the complexity of the "rake" recipe and run testrb-2 manually.
RUBY_FAKEGEM_RECIPE_TEST=none

# Same thing for the docs whose rake target just calls rdoc.
RUBY_FAKEGEM_RECIPE_DOC=rdoc
RUBY_FAKEGEM_EXTRADOC="ChangeLog README"

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
