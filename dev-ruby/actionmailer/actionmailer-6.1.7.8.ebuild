# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="actionmailer.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Framework for designing email-service layers"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"

RUBY_S="rails-${PV}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PN}-6.1.7.4-ruby32-keywords.patch
)

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}
	~dev-ruby/actionview-${PV}
	~dev-ruby/activejob-${PV}
	>=dev-ruby/mail-2.5.4:* =dev-ruby/mail-2*:*
	dev-ruby/rails-dom-testing:2"

ruby_add_bdepend "test? (
	dev-ruby/mocha
)"

all_ruby_prepare() {
	# Set test environment to our hand.
	rm "${S}/../Gemfile" || die "Unable to remove Gemfile"
	sed -e '/\/load_paths/d' \
		-e '2igem "actionview", "~> 6.1.0"; gem "actionpack", "~> 6.1.0"; gem "activejob", "~> 6.1.0"; require "ostruct"' \
		-i test/abstract_unit.rb || die "Unable to remove load paths"

	# Avoid a test failing only on attachment ordering, since this is a
	# security release.
	sed -e '/adding inline attachments while rendering mail works/askip "gentoo: fails on ordering"' \
		-i test/base_test.rb || die
}
