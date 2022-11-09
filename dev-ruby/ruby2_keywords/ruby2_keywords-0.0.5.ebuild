# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Shim library for Module#ruby2_keywords"
HOMEPAGE="https://github.com/ruby/ruby2_keywords"

LICENSE="|| ( BSD-2 Ruby-BSD )"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""
