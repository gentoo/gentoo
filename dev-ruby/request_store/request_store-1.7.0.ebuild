# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Per-request global storage for Rack"
HOMEPAGE="https://github.com/steveklabnik/request_store"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend ">=dev-ruby/rack-1.4:*"

all_ruby_prepare() {
	sed -i -e "/bundler/ s:^:#:" Rakefile || die
}
