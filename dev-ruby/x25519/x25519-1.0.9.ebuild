# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="x25519.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/x25519_ref10/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Key exchange via the X25519 (Curve25519) Elliptic Curve Diffie-Hellman function"
HOMEPAGE="https://github.com/crypto-rb/x25519"
SRC_URI="https://github.com/crypto-rb/x25519/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~arm ppc ~ppc64 ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#: ; /coverall/I s:^:#:' spec/spec_helper.rb || die

	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# The precomputed implementation only works on amd64
	if use amd64 ; then
		RUBY_FAKEGEM_EXTENSIONS+=(ext/x25519_precomputed/extconf.rb)
	else
		sed -i -e '/\(x25519_precomputed\|X25519::Provider::Precomputed\)/ s:^:#:' lib/x25519.rb || die
		rm -f spec/x25519/provider/precomputed_spec.rb || die
	fi
}
