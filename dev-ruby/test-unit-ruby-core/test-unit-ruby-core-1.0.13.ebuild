# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Additional test assertions for Ruby standard libraries"
HOMEPAGE="https://github.com/ruby/test-unit-ruby-core"

LICENSE="|| ( Ruby-BSD BSD-2 ) PSF-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"

ruby_add_rdepend "dev-ruby/test-unit"
