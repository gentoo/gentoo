# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_NAME="bio"

RUBY_FAKEGEM_EXTRAINSTALL="etc"

inherit ruby-fakegem

DESCRIPTION="An integrated environment for bioinformatics using the Ruby language"
LICENSE="Ruby"
HOMEPAGE="http://bioruby.org/"

SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"

ruby_add_rdepend "dev-ruby/libxml"
