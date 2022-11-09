# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRAINSTALL="features"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Kit to check compatibility with official cucumber implementation"
HOMEPAGE="https://cucumber.io/"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
SLOT="$(ver_cut 1)"
IUSE="test"

ruby_add_rdepend ">=dev-util/cucumber-messages-18.0.0:18"
