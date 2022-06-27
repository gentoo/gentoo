# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="History.md README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="binding that gives Ruby programmers access to arbitrary USB devices"
HOMEPAGE="https://github.com/larskanis/libusb"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND+="virtual/libusb:1"
RDEPEND+="${DEPEND}"

ruby_add_rdepend "dev-ruby/ffi:0"
ruby_add_bdepend "test? ( dev-ruby/eventmachine )"

all_ruby_prepare() {
	sed -e '/mini_portile2/d' \
		-e 's/git ls-files --/find/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid tests that try to open devices or depend on specific hardware
	rm -f test/test_libusb_{bos,descriptors}.rb || die
}

each_ruby_test() {
	${RUBY} -I.:lib -e "Dir['test/test_*.rb'].each{|f| require f}" || die
}
