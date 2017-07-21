# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23"

RUBY_FAKEGEM_EXTRAINSTALL="app spec"

inherit ruby-fakegem versionator

DESCRIPTION="Metasploit concern allows you to define concerns in app/concerns. "
HOMEPAGE="https://github.com/rapid7/metasploit-concern"
SRC_URI="mirror://rubygems/${P}.gem"

LICENSE="BSD"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~x86"
#IUSE="development test"
RESTRICT=test
IUSE=""

RDEPEND="${RDEPEND} !dev-ruby/metasploit-concern:0"

ruby_add_rdepend ">=dev-ruby/railties-4.2.6:4.2
		  >=dev-ruby/activesupport-4.2.6:4.2
		  >=dev-ruby/activemodel-2.4.6:4.2"
