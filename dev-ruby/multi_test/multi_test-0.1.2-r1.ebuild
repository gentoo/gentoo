# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="History.md README.md"

inherit ruby-fakegem

DESCRIPTION="A uniform interface for Ruby testing libraries"
HOMEPAGE="https://cucumber.io/"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86"
SLOT="0"
IUSE=""

# Tests depend on specific versions of testing frameworks where bundler
# downloads dependencies.
RESTRICT="test"
