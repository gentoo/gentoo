# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="History.md README.md VERSIONS.md"

RUBY_FAKEGEM_EXTRAINSTALL="app"

inherit ruby-fakegem

DESCRIPTION="The jQuery UI assets for the Rails 3.2+ asset pipeline"
HOMEPAGE="http://www.rubyonrails.org"

LICENSE="MIT"
SLOT="5"
KEYWORDS="~amd64 ~arm ~x64-macos"

IUSE=""

ruby_add_rdepend ">=dev-ruby/railties-3.2.16:*"
