# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRAINSTALL="README.rdoc"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A library for reading and writing arbitrary messages in DJB's maildir format"
HOMEPAGE="https://github.com/ktheory/maildir"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="2"
IUSE="test"

ruby_add_rdepend "dev-ruby/activesupport:*"

ruby_add_bdepend "
	test? ( >=dev-ruby/fakefs-0.3.2 dev-ruby/mail dev-ruby/shoulda-context dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile test/helper.rb || die
	sed -i -e 's/shoulda/shoulda-context/' test/helper.rb || die

	# Avoid tests that appear to need activesupport for .blank? support
	sed -i -e '/add and remove flags/,/^    end/ s:^:#:' test/test_message.rb || die
	sed -i -e '/be removed from flag list/,/^    end/ s:^:#:' test/test_maildir.rb || die
}
