# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="readme.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="sus"

inherit ruby-fakegem

DESCRIPTION="Test fixtures for running with OpenSSL"
HOMEPAGE="https://github.com/sus-rb/sus-fixtures-openssl"
SRC_URI="https://github.com/sus-rb/sus-fixtures-openssl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# openssl is a default gem
ruby_add_rdepend "
	>=dev-ruby/sus-0.10:0
"

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die

	# Remove the sus configuration which enabled coverage checks.
	# Its dependency is not packaged.
	rm -f config/sus.rb || die
}
