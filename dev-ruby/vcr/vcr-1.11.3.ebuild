# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/vcr/vcr-1.11.3.ebuild,v 1.1 2015/05/13 06:55:02 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Records your test suite's HTTP interactions and replay them during future test runs."
HOMEPAGE="https://github.com/myronmarston/vcr/"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="1"
IUSE="test"

# Tests require all supported HTTP libraries to be present, and it is
# not possible to avoid some of them without very extensive patches.
RESTRICT="test"
