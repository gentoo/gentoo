# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTENSION_LIBDIR="clonefile"
RUBY_FAKEGEM_EXTENSIONS=(ext/clonefile/extconf.rb)
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Implements reflink copy (copy-on-write) for supported file systems on Linux."
HOMEPAGE="https://codeberg.org/da/ruby-clonefile"

LICENSE="BSD"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~riscv"
