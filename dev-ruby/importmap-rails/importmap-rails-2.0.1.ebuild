# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_EXTRAINSTALL="app"
# Depends on appraisals, unpackaged dependencies, and unpackaged rails
# bits.
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Use ESM with importmap to manage JavaScript in Rails"
HOMEPAGE="https://github.com/rails/importmap-rails"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

ruby_add_rdepend "
	>=dev-ruby/actionpack-6.0.0:*
	>=dev-ruby/railties-6.0.0:*
"
