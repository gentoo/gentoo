# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

# Not packaged and upstream not tagged.
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Amazon Web Services event stream library"
HOMEPAGE="https://aws.amazon.com/sdk-for-ruby/"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~amd64"
IUSE=""
