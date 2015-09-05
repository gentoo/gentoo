# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

inherit ruby-fakegem versionator

RUBY_FAKEGEM_EXTRAINSTALL="app config db spec"

DESCRIPTION="Code for modeling and managing credentials in Metasploit"
HOMEPAGE="https://github.com/rapid7/metasploit-credential"
SRC_URI="mirror://rubygems/${P}.gem"

LICENSE="BSD"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/metasploit-concern-1.0.0:1.0
	>=dev-ruby/metasploit_data_models-1.2.0
	>=dev-ruby/metasploit-model-1.0.0
	dev-ruby/rubyzip:1
	dev-ruby/rubyntlm
	>=dev-ruby/railties-4.0.9:4.0
	dev-ruby/net-ssh
	dev-ruby/pg"
