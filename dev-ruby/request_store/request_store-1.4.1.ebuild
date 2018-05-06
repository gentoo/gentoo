# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Per-request global storage for Rack"
HOMEPAGE="https://github.com/steveklabnik/request_store"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rack-1.4:*"

all_ruby_prepare() {
	sed -i -e "/bundler/ s:^:#:" Rakefile || die
}
