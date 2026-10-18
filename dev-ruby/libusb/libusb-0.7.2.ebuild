# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="History.md README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="binding that gives Ruby programmers access to arbitrary USB devices"
HOMEPAGE="https://github.com/larskanis/libusb"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-libs/libusb-1.0.27:1"
RDEPEND="${DEPEND}"

ruby_add_rdepend "dev-ruby/ffi:0"
ruby_add_bdepend "test? ( dev-ruby/eventmachine )"

all_ruby_prepare() {
	sed -e '/mini_portile2/d' \
		-e 's/git ls-files --/find/' \
		-e 's/git ls-files/find */' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	# https://github.com/larskanis/libusb/tree/master#testing-libusb-gem
	# See ci task in the rakefile
	${RUBY} -I.:lib -e "Dir['test/test_libusb(_structs)?.rb'].each{|f| require f}" -- --verbose || die

}

each_ruby_install() {
	each_fakegem_install

	# This gem includes an extension that does not actually do anything
	# when using the system libusb, but newer rubygems versions still
	# require the marker to be present.
	ruby_fakegem_extensions_installed
}
