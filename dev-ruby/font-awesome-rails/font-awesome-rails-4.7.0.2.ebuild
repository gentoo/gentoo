# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Font-awesome for the asset pipeline"
HOMEPAGE="https://github.com/bokmann/font-awesome-rails https://rubygems.org/gems/font-awesome-rails"

LICENSE="MIT OFL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "<dev-ruby/railties-5.2:*
	>=dev-ruby/railties-3.2:*"
