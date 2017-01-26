# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="An HTTP/1.1 pipelining implementation atop Net::HTTP"
HOMEPAGE="http://docs.seattlerb.org/net-http-pipeline/"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64"
IUSE=""

RUBY_PATCHES=( ${PN}-accept-encoding.patch )

ruby_add_bdepend "
	dev-ruby/hoe
	test? ( dev-ruby/minitest )
"
