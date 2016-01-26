# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

inherit ruby-fakegem

DESCRIPTION="OpenSSL CBC-MAC (CCM) ruby gem"
HOMEPAGE="https://github.com/SmallLars/openssl-ccm"
SRC_URI="mirror://rubygems/${P}.gem"

LICENSE="BSD"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~x86"
RESTRICT=test
IUSE=""
