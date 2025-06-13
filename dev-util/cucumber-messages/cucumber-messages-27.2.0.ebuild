# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_GEMSPEC="cucumber-messages.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTRAINSTALL="VERSION"

inherit ruby-fakegem

DESCRIPTION="Protocol Buffer messages for Cucumber's inter-process communication"
HOMEPAGE="https://cucumber.io/"
SRC_URI="https://github.com/cucumber/messages/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="messages-${PV}/ruby"
LICENSE="MIT"

SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

ruby_add_bdepend "test? ( >=dev-util/cucumber-compatibility-kit-15.0 )"

all_ruby_prepare() {
	# The acceptance spec depends on features that are no longer shipped
	# in the compatibility kit.
	rm -f spec/cucumber/messages/acceptance_spec.rb || die
}
