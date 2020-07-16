# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="SSH private and public key generator in pure Ruby"
HOMEPAGE="https://rubygems.org/gems/sshkey"

LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
