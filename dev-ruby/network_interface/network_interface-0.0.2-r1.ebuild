# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTENSIONS=(ext/network_interface_ext/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="network_interface layer from metasploit pcaprub"
HOMEPAGE="https://github.com/rapid7/network_interface"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

# Tests are brittle as they cannot deal with all network interface configurations.
RESTRICT="test"

all_ruby_prepare() {
	sed -i -e 's:/sbin/ifconfig:/bin/ifconfig:' spec/spec_helper.rb || die
}
