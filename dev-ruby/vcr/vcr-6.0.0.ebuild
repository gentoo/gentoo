# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md CONTRIBUTING.md README.md Upgrade.md"

RUBY_FAKEGEM_GEMSPEC="vcr.gemspec"

inherit ruby-fakegem

DESCRIPTION="Records your test suite's HTTP interactions and replay them during test runs"
HOMEPAGE="https://github.com/vcr/vcr/"
SRC_URI="https://github.com/vcr/vcr/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~x86"
SLOT="$(ver_cut 1)"
IUSE="json test"

# Tests require all supported HTTP libraries to be present, and it is
# not possible to avoid some of them without very extensive patches.
RESTRICT="test"

ruby_add_rdepend "json? ( dev-ruby/json )"
