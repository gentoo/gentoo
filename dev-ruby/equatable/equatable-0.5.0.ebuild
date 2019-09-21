# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Allows ruby objects to implement equality comparison and inspection methods"
HOMEPAGE="https://github.com/piotrmurach/equatable"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
