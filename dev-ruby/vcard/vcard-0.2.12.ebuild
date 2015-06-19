# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/vcard/vcard-0.2.12.ebuild,v 1.1 2015/02/14 01:06:06 mjo Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

# Avoid the complexity of the "rake" recipe and run testrb-2 manually.
RUBY_FAKEGEM_RECIPE_TEST=none
RUBY_FAKEGEM_RECIPE_DOC=none

inherit ruby-fakegem

DESCRIPTION="Ruby vcard support extracted from Vpim"
HOMEPAGE="https://github.com/qoobaa/vcard"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

each_ruby_test() {
	ruby-ng_testrb-2 --load-path=lib --pattern='.*_test\.rb' test/
}
