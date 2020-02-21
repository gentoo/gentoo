# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

# Skip tests since they require unpackaged sequel
RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Adds around and before_all/after_all/around_all hooks for Minitest"
HOMEPAGE="https://github.com/jeremyevans/minitest-hooks"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""
