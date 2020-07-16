# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
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

all_ruby_prepare() {
	sed -i '/mini_portile2/d' ${PN}.gemspec || die

	# Avoid tests that try to open devices
	rm -f test/test_libusb_bos.rb || die
}

each_ruby_test() {
	${RUBY} -I.:lib -e "Dir['test/test_*.rb'].each{|f| require f}" || die
}
