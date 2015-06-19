# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/moneta/moneta-0.8.0.ebuild,v 1.1 2015/05/23 09:28:11 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="none"
# test is disabled for now. It requires many packages.  Test suite also
# takes very long run time and has high memory consumption.

RUBY_FAKEGEM_EXTRADOC="README.md SPEC.md"

inherit ruby-fakegem

GITHUB_USER="minad"

DESCRIPTION="A unified interface to key/value stores"
HOMEPAGE="https://github.com/minad/moneta"
SRC_URI="https://github.com/${GITHUB_USER}/moneta/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
