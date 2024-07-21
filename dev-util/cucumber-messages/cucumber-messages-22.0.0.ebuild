# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTRAINSTALL="VERSION"

inherit ruby-fakegem

DESCRIPTION="Protocol Buffer messages for Cucumber's inter-process communication"
HOMEPAGE="https://cucumber.io/"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~s390 ~sparc ~x86"
SLOT="$(ver_cut 1)"

ruby_add_bdepend "test? ( dev-util/cucumber-compatibility-kit )"
