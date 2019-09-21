# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_BINDIR="FALSE" # bin/ contains only dev tooling

inherit ruby-fakegem

DESCRIPTION="A Ruby client for the letsencrypt's ACME protocol."
HOMEPAGE="https://github.com/unixcharles/acme-client"

LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/faraday-0.9.1"
