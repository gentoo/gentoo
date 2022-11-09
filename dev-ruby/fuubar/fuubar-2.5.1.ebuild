# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="fuubar.gemspec"

inherit ruby-fakegem

DESCRIPTION="Instafailing RSpec progress bar formatter"
HOMEPAGE="https://github.com/thekompanee/fuubar"
SRC_URI="https://github.com/thekompanee/fuubar/archive/releases/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RUBY_S="${PN}-releases-v${PV}"

ruby_add_rdepend "dev-ruby/rspec:3 >=dev-ruby/ruby-progressbar-1.4:0"

each_ruby_test() {
	export CI=true
	each_fakegem_test
}
