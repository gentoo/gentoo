# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_EXTRAINSTALL="data"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit ruby-fakegem

DESCRIPTION="Color features for Ruby"
HOMEPAGE="https://github.com/red-data-tools/red-colors"
LICENSE="MIT"

SLOT="0"
KEYWORDS="amd64 ~ppc ~riscv ~x86"

ruby_add_rdepend "
	dev-ruby/json
	dev-ruby/matrix
"
