# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md REFERENCE.md"

inherit ruby-fakegem

DESCRIPTION="Faster Faker, generates dummy data"
HOMEPAGE="https://github.com/ffaker/ffaker"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	# Avoid dependency on rubocop
	sed -e '/rubocop/I s:^:#:' -i Rakefile || die

	sed -e '/test_\(image_file\|file_output_with_keyword_arguments\|file_output_with_positional_arguments\|file_with_size_as_positional_argument\)/aomit "requires network"' \
		-i test/test_image.rb || die
}
