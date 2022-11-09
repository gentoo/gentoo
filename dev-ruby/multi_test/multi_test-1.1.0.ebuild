# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="A uniform interface for Ruby testing libraries"
HOMEPAGE="https://cucumber.io/"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
SLOT="$(ver_cut 1)"
IUSE=""

# Tests depend on specific versions of testing frameworks where bundler
# downloads dependencies.
RESTRICT="test"
