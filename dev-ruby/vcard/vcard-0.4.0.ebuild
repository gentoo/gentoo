# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

# Avoid the complexity of the "rake" recipe and run testrb-2 manually.
RUBY_FAKEGEM_RECIPE_TEST=none
RUBY_FAKEGEM_RECIPE_DOC=none

inherit ruby-fakegem

DESCRIPTION="Ruby vcard support extracted from Vpim"
HOMEPAGE="https://github.com/qoobaa/vcard"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

each_ruby_test() {
	ruby-ng_testrb-2 --load-path=lib --pattern='.*_test\.rb' test/
}
