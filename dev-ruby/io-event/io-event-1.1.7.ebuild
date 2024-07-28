# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)
RUBY_FAKEGEM_EXTRADOC="readme.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="An event loop"
HOMEPAGE="https://github.com/socketry/io-event"
SRC_URI="https://github.com/socketry/io-event/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"

ruby_add_bdepend "test? ( >=dev-ruby/sus-0.6:0 )"

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die

	# Avoid dependency on unpackaged covered package
	rm -f config/sus.rb || die
}

each_ruby_test() {
	${RUBY} -S sus-parallel || die
}
