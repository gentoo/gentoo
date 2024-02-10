# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

# Upstream has specs but they are not available in the gem and the
# repository upstream is not tagged for this.
RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

inherit ruby-fakegem

DESCRIPTION="Provides deploying functionality for Nanoc"
HOMEPAGE="https://nanoc.app/"
LICENSE="MIT"

KEYWORDS="~amd64 ~riscv"
SLOT="$(ver_cut 1)"
IUSE=""

ruby_add_rdepend "
	www-apps/nanoc-checking:1
	>=www-apps/nanoc-cli-4.11.15:0
	>=www-apps/nanoc-core-4.11.15:0
"
