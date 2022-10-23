# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Provides a class-level mixin to make fiber local state easy"
HOMEPAGE="https://github.com/socketry/fiber-local"
SRC_URI="https://github.com/socketry/fiber-local/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~sparc"
IUSE=""

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die

	sed -i -e '/\(bundler\|covered\)/ s:^:#:' spec/spec_helper.rb || die
}
