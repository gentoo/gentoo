# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Potentially the best command line gister."
HOMEPAGE="https://github.com/defunkt/gist"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# dev-python/txgithub also installs a 'gist' binary.
RDEPEND="!dev-python/txgithub"

ruby_add_bdepend "test? ( dev-ruby/webmock )"
