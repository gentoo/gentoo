# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Registry for information about MIME media type definitions"
HOMEPAGE="https://github.com/mime-types/mime-types-data"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
