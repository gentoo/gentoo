# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_GEMSPEC="network_interface.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTENSIONS=(ext/network_interface_ext/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="network_interface layer from metasploit pcaprub"
HOMEPAGE="https://github.com/rapid7/network_interface"
SRC_URI="https://github.com/rapid7/network_interface/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

# Tests are brittle as they cannot deal with all network interface configurations.
RESTRICT="test"

all_ruby_prepare() {
	sed -i -e 's:/sbin/ifconfig:/bin/ifconfig:' spec/spec_helper.rb || die

	sed --i -e 's/__dir__/"."/' -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
