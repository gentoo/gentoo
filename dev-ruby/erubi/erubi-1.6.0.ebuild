# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_TASK_TEST="spec"

inherit ruby-fakegem

DESCRIPTION="a ERB template engine for ruby; a simplified fork of Erubis"
HOMEPAGE="https://github.com/jeremyevans/erubi"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest )"
