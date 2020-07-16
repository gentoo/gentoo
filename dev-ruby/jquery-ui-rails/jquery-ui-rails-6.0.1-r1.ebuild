# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="History.md README.md VERSIONS.md"

RUBY_FAKEGEM_EXTRAINSTALL="app"

inherit ruby-fakegem

DESCRIPTION="The jQuery UI assets for the Rails 3.2+ asset pipeline"
HOMEPAGE="https://github.com/joliss/jquery-ui-rails"

LICENSE="MIT"
SLOT="6"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos"

IUSE=""

ruby_add_rdepend ">=dev-ruby/railties-3.2.16:*"
