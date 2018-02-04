# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A Javascript code obfuscator"
HOMEPAGE="https://github.com/rapid7/jsobfu"

LICENSE="BSD"
#rapid7 gems are slotted so we can have multiple versions installed at once to support multiple versions of metasploit
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend "!dev-ruby/jsobfu:0
		>=dev-ruby/rkelly-remix-0.0.6:0"

ruby_add_bdepend "test? ( dev-ruby/execjs )"

all_ruby_prepare() {
	sed -i -e '/simplecov/ s:^:#:' \
		-e '/config.\(color\|tty\|formatter\)/ s:^:#:' \
		spec/spec_helper.rb || die
}

all_ruby_install() {
	all_fakegem_install

	ruby_fakegem_binwrapper jsobfu jsobfu-${PV}
}
