# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

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

each_ruby_configure() {
	${RUBY} -Cext/ed25519_ref10 extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/ed25519_ref10
	cp ext/ed25519_ref10/ed25519_ref10.so lib/ || die
}
