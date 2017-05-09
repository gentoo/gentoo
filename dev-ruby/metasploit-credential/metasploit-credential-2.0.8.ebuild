# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

RUBY_FAKEGEM_EXTRAINSTALL="app config db spec"

DESCRIPTION="Code for modeling and managing credentials in Metasploit"
HOMEPAGE="https://github.com/rapid7/metasploit-credential"

LICENSE="BSD"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm"
IUSE=""
RESTRICT=test

ruby_add_rdepend "dev-ruby/metasploit-concern:2.0
	>=dev-ruby/metasploit_data_models-1.2.0:*
	>=dev-ruby/metasploit-model-1.0.0
	dev-ruby/rubyzip:1
	dev-ruby/rubyntlm
	>=dev-ruby/railties-4.2.6:4.2
	dev-ruby/pg"
