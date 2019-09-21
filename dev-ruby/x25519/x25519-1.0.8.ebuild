# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="x25519.gemspec"

inherit ruby-fakegem

DESCRIPTION="Key exchange via the X25519 (Curve25519) Elliptic Curve Diffie-Hellman function"
HOMEPAGE="https://github.com/crypto-rb/x25519"
SRC_URI="https://github.com/crypto-rb/x25519/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#: ; /coverall/I s:^:#:' spec/spec_helper.rb || die

	sed -i -e 's/git ls-files -z/find . -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_configure() {
	${RUBY} -Cext/x25519_precomputed extconf.rb || die
	${RUBY} -Cext/x25519_ref10 extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/x25519_precomputed
	cp ext/x25519_precomputed/x25519_precomputed.so lib/ || die
	emake V=1 -Cext/x25519_ref10
	cp ext/x25519_ref10/x25519_ref10.so lib/ || die
}
