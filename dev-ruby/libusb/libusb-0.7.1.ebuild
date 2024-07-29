# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="History.md README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="binding that gives Ruby programmers access to arbitrary USB devices"
HOMEPAGE="https://github.com/larskanis/libusb"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND+=">=dev-libs/libusb-1.0.27:1"
RDEPEND+="${DEPEND}"

ruby_add_rdepend "dev-ruby/ffi:0"
ruby_add_bdepend "test? ( dev-ruby/eventmachine )"

all_ruby_prepare() {
	sed -e '/mini_portile2/d' \
		-e 's/git ls-files --/find/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid tests that try to open devices or depend on specific hardware
	rm -f test/test_libusb_{bos,bulk_stream_transfer,descriptors}.rb || die
}

each_ruby_test() {
	${RUBY} -I.:lib -e "Dir['test/test_*.rb'].each{|f| require f}" || die
}

each_ruby_install() {
	each_fakegem_install

	# This gem includes an extension that does not actually do anything
	# when using the system libusb, but newer rubygems versions still
	# require the marker to be present.
	ruby_fakegem_extensions_installed
}
