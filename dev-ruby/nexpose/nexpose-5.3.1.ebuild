# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
inherit ruby-fakegem

DESCRIPTION="API client for Nexpose vulnerability managment product"
HOMEPAGE="https://github.com/rapid7/nexpose-client https://rubygems.org/gems/nexpose"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
