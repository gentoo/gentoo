# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_GEMSPEC="cucumber-html-formatter.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRAINSTALL="assets"

inherit ruby-fakegem

DESCRIPTION="HTML formatter for Cucumber"
HOMEPAGE="https://cucumber.io/"
SRC_URI="https://github.com/cucumber/html-formatter/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="html-formatter-${PV}/ruby"

LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
SLOT="$(ver_cut 1)"
IUSE="test"

ruby_add_rdepend "
	dev-util/cucumber-messages:22
"

all_ruby_prepare() {
	# Require a specific version of cucumber-messages that is compatible
	# throughout the cucumber stack.  Drop compatibility-kit since it
	# does not work with the supported versions of cucumber-messages and
	# newer versions are completely broken.
	sed -e '2igem "cucumber-messages", "~>22.0"' \
		-e '/compatibility-kit/ s:^:#:' \
		-i spec/spec_helper.rb || die

	sed -e '/when using the CCK/,/^  end/ s:^:#:' \
		-i spec/cucumber/html_formatter/formatter_spec.rb || die

}
