# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="binding that gives Ruby programmers access to arbitrary USB devices"
HOMEPAGE="https://github.com/larskanis/libusb"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
PDEPEND="virtual/ruby-ffi
	virtual/libusb"

all_ruby_prepare() {
	sed -i '/mini_portile2/d' ${PN}.gemspec || die
	sed -i '/mini_portile2/d' lib/libusb/libusb_recipe.rb || die
	sed -i '/mini_portile2/d' lib/libusb/gem_helper.rb || die
	sed -i '/mini_portile2/d' lib/libusb/dependencies.rb || die
}
