# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINDIR="exe"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Easily build Ruby native extensions in Rust"
HOMEPAGE="https://github.com/oxidize-rb/rb-sys"

LICENSE="MIT Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"

ruby_add_rdepend "~dev-ruby/rake-compiler-dock-1.10.0"
