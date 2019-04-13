# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Per-request global storage for Rack"
HOMEPAGE="https://github.com/steveklabnik/request_store"

LICENSE="MIT"
SLOT="1.0.5"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_all_prepare() {
	sed -i -e "/bundler/d" Rakefile || die
}
