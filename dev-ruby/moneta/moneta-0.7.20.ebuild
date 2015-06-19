# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/moneta/moneta-0.7.20.ebuild,v 1.1 2014/12/29 12:45:10 naota Exp $

EAPI="4"
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="none"
# test is disabled for now. It requires many packages.

RUBY_FAKEGEM_EXTRADOC="README.md SPEC.md"

inherit ruby-fakegem

GITHUB_USER="minad"

DESCRIPTION="A unified interface to key/value stores"
HOMEPAGE="http://github.com/minad/moneta"
SRC_URI="http://github.com/${GITHUB_USER}/moneta/tarball/v${PV} -> ${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RUBY_S="${GITHUB_USER}-${PN}-*"

# ruby_add_bdepend "test? (
# 		>=dev-ruby/actionpack-3.2.11
# 	)"
