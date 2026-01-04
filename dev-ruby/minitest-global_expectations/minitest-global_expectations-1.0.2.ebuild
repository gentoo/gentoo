# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_GEMSPEC="minitest-global_expectations.gemspec"

inherit ruby-fakegem

DESCRIPTION="Support minitest expectation methods for all objects"
HOMEPAGE="https://github.com/jeremyevans/minitest-global_expectations"
SRC_URI="https://github.com/jeremyevans/minitest-global_expectations/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

ruby_add_rdepend ">=dev-ruby/minitest-5"
