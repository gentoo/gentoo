# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_VERSION="1.0.1.1"

COMMIT="89e3f621132c2571d5f7c636b3962ff1b0a64564"

inherit ruby-fakegem

DESCRIPTION="ruby interface for blinkstick via libusb"
HOMEPAGE="https://github.com/arvydas/blinkstick-ruby"
SRC_URI="https://github.com/arvydas/blinkstick-ruby/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-ruby-${COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

ruby_add_rdepend "
	>=dev-ruby/color-1.4.2
	>=dev-ruby/libusb-0.4.0
"

all_ruby_install() {
	if use examples; then
		insinto /usr/share/${PN}
		doins example-*.rb
	fi
	all_fakegem_install
}

each_ruby_install() {
	mkdir -p lib/${PN}
	mv ${PN}.rb lib
	cat <<EOF >> lib/${PN}/version.rb
class BlinkStick
	VERSION = "1.0.1.1"
end

EOF
	each_fakegem_install
}
