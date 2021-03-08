# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md REFERENCE.md"

inherit ruby-fakegem

DESCRIPTION="Faster Faker, generates dummy data"
HOMEPAGE="https://github.com/emmanueloga/ffaker"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	sed -i -e '/test_image_file/aomit "network"' test/test_image.rb || die
}
