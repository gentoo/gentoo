# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
inherit ruby-fakegem

DESCRIPTION="RSpec helpers for buffering and detecting file descriptor leaks"
HOMEPAGE="https://github.com/socketry/rspec-files"
SRC_URI="https://github.com/socketry/rspec-files/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~sparc"
IUSE=""

ruby_add_rdepend "dev-ruby/rspec:3"

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die
	sed -i -E 's/require '"'"'covered\/rspec'"'"'//g' "spec/spec_helper.rb" || die
}
