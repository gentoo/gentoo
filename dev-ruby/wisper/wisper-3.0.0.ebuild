# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A micro library providing objects with Publish-Subscribe capabilities"
HOMEPAGE="https://github.com/krisleech/wisper"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

all_ruby_prepare() {
	sed -i -e '/coverall/I s:^:#:' spec/spec_helper.rb || die

	# Account for 'inspect' differences in ruby 3.4
	sed -e '/expect/ s/{:x=>:y}/#{{:x=>:y}.inspect}/' \
		-i spec/lib/wisper/broadcasters/logger_broadcaster_spec.rb || die
}
