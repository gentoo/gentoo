# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

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
