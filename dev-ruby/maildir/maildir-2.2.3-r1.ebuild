# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRAINSTALL="README.rdoc"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A library for reading and writing arbitrary messages in DJB's maildir format"
HOMEPAGE="https://github.com/ktheory/maildir"
LICENSE="MIT"

SLOT="2"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "
	test? ( >=dev-ruby/fakefs-0.3.2 dev-ruby/mail dev-ruby/shoulda dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	sed -e '/bundler/ s:^:#:' \
		-e '/pride/ s:^:#:' \
		-i Rakefile test/helper.rb || die

	# Avoid tests that appear to need activesupport for .blank? support
	sed -i -e '/add and remove flags/,/^    end/ s:^:#:' test/test_message.rb || die
	sed -i -e '/be removed from flag list/,/^    end/ s:^:#:' test/test_maildir.rb || die

	# Fix deprecations
	sed -e 's/File.exists/File.exist/' \
		-i test/test_message.rb || die
}
