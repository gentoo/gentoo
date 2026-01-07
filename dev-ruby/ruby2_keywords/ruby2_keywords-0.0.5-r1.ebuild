# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Shim library for Module#ruby2_keywords"
HOMEPAGE="https://github.com/ruby/ruby2_keywords"

LICENSE="|| ( BSD-2 Ruby-BSD )"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
