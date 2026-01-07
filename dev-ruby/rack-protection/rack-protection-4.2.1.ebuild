# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

# There are no specs in the gem and the source cannot be downloaded separately.
RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="This gem protects against typical web attacks"
HOMEPAGE="https://sinatrarb.com/protection/"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos ~x64-solaris"

ruby_add_rdepend "
	>=dev-ruby/base64-0.1.0
	>=dev-ruby/logger-1.6.0
	|| ( dev-ruby/rack:3.2 dev-ruby/rack:3.1 dev-ruby/rack:3.0 )
"
