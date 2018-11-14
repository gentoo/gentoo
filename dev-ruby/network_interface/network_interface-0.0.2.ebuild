# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_RECIPE_TEST="rspec"

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

each_ruby_configure() {
	${RUBY} -C ext/network_interface_ext extconf.rb || die
}

each_ruby_compile() {
	emake -C ext/network_interface_ext V=1
	cp ext/network_interface_ext/network_interface_ext.so lib/ || die
}
