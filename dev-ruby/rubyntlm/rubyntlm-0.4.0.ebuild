# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

inherit ruby-fakegem

DESCRIPTION="Ruby/NTLM provides message creator and parser for the NTLM authentication."
HOMEPAGE="http://rubygems.org/gems/rubyntlm"
SRC_URI="mirror://rubygems/${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
