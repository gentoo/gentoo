# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

# The specs require a number of gems to be installed in a temporary
# directory, but this requires network access. They also don't work
# when run with a path that contains "-".
RUBY_FAKEGEM_RECIPE_TEST="none"

# No documentation task
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

RUBY_FAKEGEM_BINDIR="exe"

inherit ruby-fakegem

DESCRIPTION="An easy way to vendor gem dependencies"
HOMEPAGE="https://github.com/rubygems/rubygems"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc test"

ruby_add_rdepend virtual/rubygems

RDEPEND+=" dev-vcs/git"
