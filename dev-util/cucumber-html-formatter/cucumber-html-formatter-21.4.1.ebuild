# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRAINSTALL="assets"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="HTML formatter for Cucumber"
HOMEPAGE="https://cucumber.io/"

# Can be used for specs but requires assets to be created from npm
#SRC_URI="https://github.com/cucumber/html-formatter/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
#RUBY_S="html-formatter-${PV}/ruby"

LICENSE="MIT"

SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"

# Specs are no longer available in the distributed gem
RESTRICT="test"

ruby_add_rdepend "
	dev-util/cucumber-messages:22
	!<dev-util/cucumber-html-formatter-20.4.0-r1:20
"
