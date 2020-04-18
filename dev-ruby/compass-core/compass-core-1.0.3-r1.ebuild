# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRAINSTALL="data stylesheets templates VERSION"

inherit ruby-fakegem versionator

DESCRIPTION="Compass Stylesheet Authoring Framework"
HOMEPAGE="http://compass-style.org/"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/multi_json-1.0
	>=dev-ruby/sass-3.3.0:* <dev-ruby/sass-3.5:*
"
