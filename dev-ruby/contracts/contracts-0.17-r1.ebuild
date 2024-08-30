# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.markdown README.md TODO.markdown TUTORIAL.md"

inherit ruby-fakegem

DESCRIPTION="provides contracts for Ruby"
HOMEPAGE="https://github.com/egonSchiele/contracts.ruby"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ~mips ~ppc ppc64 ~riscv ~s390 sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-ruby32.patch
)

each_ruby_test() {
	# COLUMNS needed for:
	# ./spec/contracts_spec.rb:654 # Contracts: Contracts to_s formatting in expected should wrap and pretty print for long return contracts
	# ./spec/contracts_spec.rb:643 # Contracts: Contracts to_s formatting in expected should wrap and pretty print for long param contracts
	local -x COLUMNS=80
	each_fakegem_test
}
