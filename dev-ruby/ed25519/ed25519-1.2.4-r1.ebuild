# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTENSIONS=(ext/ed25519_ref10/extconf.rb)

RUBY_FAKEGEM_GEMSPEC="ed25519.gemspec"

inherit ruby-fakegem

DESCRIPTION="Library for the Ed25519 public-key signature system"
HOMEPAGE="https://github.com/crypto-rb/ed25519"
SRC_URI="https://github.com/crypto-rb/ed25519/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' spec/spec_helper.rb || die
}
