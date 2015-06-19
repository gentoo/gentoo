# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/bouncy-castle-java/bouncy-castle-java-1.5.0146.1.ebuild,v 1.4 2012/08/05 02:34:08 flameeyes Exp $

EAPI=4

USE_RUBY=jruby

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="A gem redistribution of 'Legion of the Bouncy Castle Java cryptography APIs'"
HOMEPAGE="http://www.bouncycastle.org/java.html"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
