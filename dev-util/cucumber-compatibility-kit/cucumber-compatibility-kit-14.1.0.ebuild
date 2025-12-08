# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRAINSTALL="features"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Kit to check compatibility with official cucumber implementation"
HOMEPAGE="https://cucumber.io/"
LICENSE="MIT"

SLOT="$(ver_cut 1)"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"

ruby_add_rdepend "
	dev-util/cucumber-messages:22
	>=dev-ruby/rake-13.0.6 =dev-ruby/rake-13*
	>=dev-ruby/rspec-3.12.0:3
"
