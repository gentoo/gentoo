# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

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
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RUBY_S="${PN}-releases-v${PV}"

ruby_add_rdepend "dev-ruby/rspec:3 >=dev-ruby/ruby-progressbar-1.4:0"

each_ruby_test() {
	export CI=true
	each_fakegem_test
}
